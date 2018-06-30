import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => new _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:new Container(
         padding: const EdgeInsets.only(left: 20.0, right: 20.0),
       child: new Center(
         child: new Column(
           children: <Widget>[
                new Text(" What iDetect is.", style:new TextStyle(fontWeight:FontWeight.bold,)),
                new Text("iDetect is an app which incorporates Machine Learning and Artificial Intelligence to detect eye diseases."),

                new Text(" Who can use iDetect.", style:new TextStyle(fontWeight:FontWeight.bold)) ,
                new Text(" We want our app to be absolutely accessible to anyone, but not to be misused.Through our service, we would like to encourage more poeple to go for regular eye exams even if there are no diseases detected in their eyes"),
            
            new Divider(height:20.0,),
                new Text("Version", style:new TextStyle(fontWeight:FontWeight.bold,fontStyle:FontStyle.italic)),
                new Text("1.0.7-259532-d213d38", style:new TextStyle(color:Colors.purpleAccent)),
            new Divider(height:20.0,),
                new Text("2018 \u00a9 The iDetect Team"),
           ],
         )
       ),


      ),
      
    );
  }
}