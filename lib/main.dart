import 'package:flutter/material.dart';
import 'package:idetect/drawer.dart';
import 'dart:ui';
import 'camera_page.dart';
import 'circle_button.dart';
import 'package:idetect/exercises.dart';
import 'opthalmologists.dart';

import 'about.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'iDetect',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
      routes: <String, WidgetBuilder> {
        '/homepage': (BuildContext context) => new MyHomePage(),
        '/drawer': (BuildContext context) => new DrawerDemo(),
        '/exercises': (BuildContext context) => new Exercises(),
        '/opthalmologists': (BuildContext context) => new Opthalmologists(),
        '/about': (BuildContext context) => new About(),
      },
    );
  }
  
}




class MyHomePage extends StatefulWidget {
  static const String routeName = '/material/bottom_app_bar';

  @override
  State createState() => new _MyHomePageState();
}



// Flutter generally frowns upon abbrevation however this class uses two
// abbrevations extensively: "fab" for floating action button, and "bab"
// for bottom application bar.

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double buttonDiameter = 10.0;
  double offsetRatio = 0.0;
  double offsetFromOne = 0.0;
  bool overlayVisibility = false;
  // FAB shape
  static const _ChoiceValue<Widget> kNoFab = const _ChoiceValue<Widget>(
    title: 'None',
    label: 'do not show a floating action button',
    value: null,
  );

  static _ChoiceValue<Widget> kCircularFab = _ChoiceValue<Widget>(
    title: 'Circular',
    label: 'circular floating action button',
    value:  FloatingActionButton(
      // onPressed: _showSnackbar,
      onPressed: () {
        capturePic();
        
      },
      child: const Icon(Icons.camera),
      backgroundColor: Colors.orange,
    ),
  );

  static const _ChoiceValue<Widget> kDiamondFab = const _ChoiceValue<Widget>(
    title: 'Diamond',
    label: 'diamond shape floating action button',
    value: const _DiamondFab(
      onPressed: _showSnackbar,
      child: const Icon(Icons.camera),
    ),
  );

  // Notch

  static const _ChoiceValue<bool> kShowNotchTrue = const _ChoiceValue<bool>(
    title: 'On',
    label: 'show bottom appbar notch',
    value: true,
  );

  static const _ChoiceValue<bool> kShowNotchFalse = const _ChoiceValue<bool>(
    title: 'Off',
    label: 'do not show bottom appbar notch',
    value: false,
  );

  // FAB Position

  static const _ChoiceValue<FloatingActionButtonLocation> kFabEndDocked = const _ChoiceValue<FloatingActionButtonLocation>(
    title: 'Attached - End',
    label: 'floating action button is docked at the end of the bottom app bar',
    value: FloatingActionButtonLocation.endDocked,
  );

  static const _ChoiceValue<FloatingActionButtonLocation> kFabCenterDocked = const _ChoiceValue<FloatingActionButtonLocation>(
    title: 'Attached - Center',
    label: 'floating action button is docked at the center of the bottom app bar',
    value: FloatingActionButtonLocation.centerDocked,
  );

  static const _ChoiceValue<FloatingActionButtonLocation> kFabEndFloat= const _ChoiceValue<FloatingActionButtonLocation>(
    title: 'Free - End',
    label: 'floating action button floats above the end of the bottom app bar',
    value: FloatingActionButtonLocation.endFloat,
  );

  static const _ChoiceValue<FloatingActionButtonLocation> kFabCenterFloat = const _ChoiceValue<FloatingActionButtonLocation>(
    title: 'Free - Center',
    label: 'floating action button is floats above the center of the bottom app bar',
    value: FloatingActionButtonLocation.centerFloat,
  );

  static void _showSnackbar() {
    const String text =
      "When the Scaffold's floating action button location changes, "
      'the floating action button animates to its new position.'
      'The BottomAppBar adapts its shape appropriately.';
    _scaffoldKey.currentState.showSnackBar(
      const SnackBar(content: const Text(text)),
    );
  }

  // App bar color

  static const List<_NamedColor> kBabColors = const <_NamedColor>[
    const _NamedColor(null, 'Clear'),
    const _NamedColor(const Color(0xFFFFC100), 'Orange'),
    const _NamedColor(const Color(0xFF91FAFF), 'Light Blue'),
    const _NamedColor(const Color(0xFF00D1FF), 'Cyan'),
    const _NamedColor(const Color(0xFF00BCFF), 'Cerulean'),
    const _NamedColor(const Color(0xFF009BEE), 'Blue'),
  ];

  _ChoiceValue<Widget> _fabShape = kCircularFab;
  _ChoiceValue<FloatingActionButtonLocation> _fabLocation = kFabCenterDocked;

  void overlayTap() {
    setState(() {
      overlayVisibility = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: new Stack(
            children: <Widget>[

              new CameraHome(),
              new ControlsLayer(
                offset: offsetRatio,
                onCameraTap: () async {
                  await flipCamera();
                  setState(() {});
                },
              ),
              
            ],
      ),
      floatingActionButton: _fabShape.value,
      floatingActionButtonLocation: _fabLocation.value,
      bottomNavigationBar: new _DemoBottomAppBar(
        color: const Color(0xFF00BCFF),
        fabLocation: _fabLocation.value,
      ),
    );
  }

  var done = false;
  static String loadingText = 'Loading.... Please wait...';

  static var bodyProgress = new Container(
    child: new Stack(
      children: <Widget>[
        new Container(
          alignment: AlignmentDirectional.center,
          decoration: new BoxDecoration(
            color: Colors.white70,
          ),
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.blue[200],
              borderRadius: new BorderRadius.circular(10.0)
            ),
            width: 300.0,
            height: 200.0,
            alignment: AlignmentDirectional.center,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: new SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: new CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child: new Center(
                    child: new Text(loadingText,
                      style: new TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _ChoiceValue<T> {
  const _ChoiceValue({ this.value, this.title, this.label });

  final T value;
  final String title;
  final String label; // For the Semantics widget that contains title

  @override
  String toString() => '$runtimeType("$title")';
}


class _NamedColor {
  const _NamedColor(this.color, this.name);

  final Color color;
  final String name;
}


class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    this.color,
    this.fabLocation
  });

  final Color color;
  final FloatingActionButtonLocation fabLocation;


  static final List<FloatingActionButtonLocation> kCenterLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContents = <Widget> [
      new IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          showModalBottomSheet<Null>(
            context: context,
            builder: (BuildContext context) => _DemoDrawer(),
          );
        },
      ),
    ];

    if (kCenterLocations.contains(fabLocation)) {
      rowContents.add(
        const Expanded(child: const SizedBox()),
      );
    }

    rowContents.addAll(<Widget> [
      new IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          Scaffold.of(context).showSnackBar(
            const SnackBar(content: const Text('Welcome to iDetect.')),
          );
        },
      ),
    ]);

    return new BottomAppBar(
      color: color,
      child: new Row(children: rowContents),
    );
  }
}

class _DemoDrawer extends StatefulWidget {
  static const String routeName = '/material/bottom_app_bar';

  @override
  State createState() => new _DemoDrawerState();
}


// A drawer that pops up from the bottom of the screen.
class _DemoDrawerState extends State<_DemoDrawer> {

  void _navExcerciseScreen() {
    Navigator.of(context).pushNamed('/exercises');
  }
  void _navOpthScreen() {
    Navigator.of(context).pushNamed('/opthalmologists');
  }
  void _navAboutScreen() {
    Navigator.of(context).pushNamed('/about');
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Column(
        children:  <Widget>[
          new ListTile(
            leading: const Icon(Icons.remove_red_eye),
            title: const Text('Exercises'),
            onTap: _navExcerciseScreen,
          ),
          new ListTile(
            leading: const Icon(Icons.local_hospital),
            title: const Text('Opthalmologists'),
            onTap: _navOpthScreen,
          ),
          new ListTile(
            leading: const Icon(Icons.lightbulb_outline),
            title: const Text('About'),
            onTap: _navAboutScreen,
          ),
        ],
      ),
    );
  }
}

// A diamond-shaped floating action button.
class _DiamondFab extends StatelessWidget {
  const _DiamondFab({
    this.child,
    this.onPressed,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new Material(
      shape: const _DiamondBorder(),
      color: Colors.orange,
      child: new InkWell(
        onTap: onPressed,
        child: new Container(
          width: 56.0,
          height: 56.0,
          child: IconTheme.merge(
            data: new IconThemeData(color: Theme.of(context).accentIconTheme.color),
            child: child,
          ),
        ),
      ),
      elevation: 6.0,
    );
  }
}

class _DiamondBorder extends ShapeBorder {
  const _DiamondBorder();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    return new Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width  / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}
