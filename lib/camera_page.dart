import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';

import 'predict.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


List<CameraDescription> _cameras;
CameraController _controller;

IconData _cameraLensIcon(CameraLensDirection currentDirection) {
  switch (currentDirection) {
    case CameraLensDirection.back:
      return Icons.camera_front;
    case CameraLensDirection.front:
      return Icons.camera_rear;
    case CameraLensDirection.external:
      return Icons.camera;
  }

  throw new ArgumentError('Unknown lens direction');
}

void playPause() {
  
  if (_controller != null) {
    if (_controller.value.isInitialized) {
      // _controller.dispose();
    } else {
      _controller.initialize();
    }
  }
}
  
Future<Null> _restartCamera(CameraDescription description) async {
    final CameraController tempController = _controller;
    _controller = null;
    await tempController?.dispose();
    _controller = new CameraController(description, ResolutionPreset.high);
    await _controller.initialize();
}

Future<Null> flipCamera() async {
  if (_controller != null) {
    var newDescription = _cameras.firstWhere((desc) {
      return desc.lensDirection != _controller.description.lensDirection;
    });

    await _restartCamera(newDescription);
  }
}

Future<Null> capturePic() async {
  print('-----------------------------------------------');
  print('Capturepic called');
  new _CameraHomeState().onTakePictureButtonPressed();
}

class CameraIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      return new Icon(
        _cameraLensIcon(_controller.description.lensDirection),
        color: Colors.white,
      );
    } else {
      return new Container();
    }
  }
}

class CameraHome extends StatefulWidget {
  @override
  _CameraHomeState createState() => new _CameraHomeState();
  
}

class _CameraHomeState extends State<CameraHome> with WidgetsBindingObserver {
  bool opening = false;
  String imagePath;
  int pictureCount = 0;
  bool overlayVisibility = false;
  bool flagged = false;


  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addObserver(this);

    availableCameras().then((cams) {
      _cameras = cams;
      _controller = new CameraController(_cameras[1], ResolutionPreset.high);
      _controller.initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    print('diposed called');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      var description = _cameras.firstWhere((desc) {
        return desc.lensDirection == _controller.description.lensDirection;
      });

      _restartCamera(description)
        .then((_) { 
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenDimension = MediaQuery.of(context).size;
    final List<Widget> columnChildren = <Widget>[];

    if (_controller != null && _controller.value.isInitialized) {
      columnChildren.add(new Expanded(
        child: new FittedBox(
          fit: BoxFit.fitHeight,
          alignment: AlignmentDirectional.center,
          child: new Container(
            width: screenDimension.width,
            height: screenDimension.height * _controller.value.aspectRatio,
            child: new CameraPreview(_controller),
          ) 
        )
      ));
    } else {
      columnChildren.add(new Center(
        child: new Directionality(
          textDirection: TextDirection.ltr,
          child: new Icon(Icons.question_answer)
        )
      ));
    }
    
    return new Column(
      children: columnChildren,
    );
  }
  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = new CameraController(cameraDescription, ResolutionPreset.high);

    // If the _controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
       
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    print('-----------------------------------------------');
    print('OnTakePicture Called');
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          _controller.dispose();
          _controller = null;
        });
        
        if (filePath != null)
          print('Picture saved to $filePath');
      }
    });
  }

  void uploadFile(File imageFile) async {    
    print('----------xxxxxxxxxxxxxxxxxxxxxxx----------');
    print('Upload called');
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse('https://grubscan-api.herokuapp.com/v1/images');

     var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('picture', stream, length,
          filename: basename(imageFile.path));
          //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        double cataractValue, noCataractValue;
          fetchMessage(json.decode(value)).then((response){
          //fetchMessage('https://vignette.wikia.nocookie.net/phobia/images/1/1e/Eye.jpg/revision/latest/scale-to-width-down/300?cb=20161109055221').then((response){
            final responseJson = json.decode(response.body);
            print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
            var prediction = new Prediction.fromJson(responseJson);
            print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
            cataractValue = double.parse(prediction.cataractValue.toString());
            noCataractValue = double.parse(prediction.noCataractValue.toString());
            print(prediction.noCataractValue.toString());
            print(prediction.cataractValue.toString());   
          }).then((onValue) {
            overlayVisibility = true;
            if (cataractValue * 100 > noCataractValue * 100) {
            String cataractValueDec = (cataractValue*100).toStringAsFixed(2);
            String text = '$cataractValueDec% probable that you have cataract';
            print('cataract found');
          } else if (cataractValue * 100 < noCataractValue * 100) {
            String noCataractValueDec = (noCataractValue*100).toStringAsFixed(2);
            String text = '$noCataractValueDec% probable that you don\'t have cataract';
            print('cataract not found');
            
          }
          });

      });
    }
  void overlayTap() {
  }

  Future<String> takePicture() async {
    print('-----------------------------------------------');
    print('TakePicture Called');
    if (!_controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    final String filePath = '$dirPath/${timestamp()}.jpg';
    try {
      await new Directory(dirPath).create(recursive: true)
      .then((value) {
          print(value.toString());
        });
    } on Exception catch (e) {
      print('---------------------------------------------');
      print(e.toString());
    }

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await _controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    uploadFile(new File(filePath));
    return filePath;
  }

  void _showCameraException(CameraException e) {
    print(e.description.toString());
  }
}

