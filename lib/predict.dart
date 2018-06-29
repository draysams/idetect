import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


Future<http.Response> fetchMessage(String text) async {
  print("In fetch message");
  var url = "https://api.clarifai.com/v2/models/Cataract/outputs";
  var body = json.encode({
    "inputs": [
      {
        "data": {
          "image": {
            "url": text
          }
        }
      }
    ],
    "model":{
      "output_info":{
        "output_config":{
          "language":"en"
        }
      }
    }
  });
  var headers = {
    'Authorization' : 'Key d81287804e904e2294fde4fd333ad082',
    'Content-type' : "application/json", 
  };
  // request.headers[HttpHeaders.CONTENT_TYPE] = 'application/json; charset=utf-8';
  // request.headers["App-Key"] = 'e71a9f25b06622b427c4ec0894b41ec4';
  // request.headers["App-Id"] = '8f007758';
  // request.bodyFields = body;
  // var future = client.send(request).then((response)
  //     => response.stream.bytesToString().then((value)
  //         => print(value.toString()))).catchError((error) => print(error.toString()));
  final response =
      await http.post(url, body: body, headers: headers);
  print('****************************************************');
  print("response : " + response.body.toString());
  print('****************************************************');

  return response;
}


class Prediction {
  var outputs;
  var link;
  var noCataractValue;
  var cataractValue;



  Prediction({this.outputs, this.link, this.noCataractValue, this.cataractValue});

  factory Prediction.fromJson(Map<dynamic, dynamic> json) {
    return new Prediction(
      outputs: json['outputs'],
      link: json['outputs'][0]['input']['data']['image']['url'],
      noCataractValue: json['outputs'][0]['data']['concepts'][0]['value'],
      cataractValue: json['outputs'][0]['data']['concepts'][1]['value'],
    );
  }
}