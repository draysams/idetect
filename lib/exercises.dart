// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Routines {
  const Routines({
    this.assetName,
    this.title,
    this.description,
  });

  final String assetName;
  final String title;
  final List<String> description;

  bool get isValid => assetName != null && title != null && description?.length == 3;
}

final List<Routines> destinations = <Routines>[
  const Routines(
    assetName: 'assets/1.png',
    description: const <String>[
      'Exercise 1',
      'Up and Down',
      'Vertical Motion',
    ],
  ),
  const Routines(
    assetName: 'assets/2.png',
    description: const <String>[
      'Exercise 2',
      'Left and Right',
      'Horizontal Motion',
    ],
  ),
  const Routines(
    assetName: 'assets/3.png',
    description: const <String>[
      'Exercise 3',
      'Top Left',
      'Diagonal Motion',
    ],
  ),
  const Routines(
    assetName: 'assets/4.png',
    description: const <String>[
      'Exercise 4',
      'Left and Right',
      'Rotation',
    ],
  ),
  const Routines(
    assetName: 'assets/5.png',
    description: const <String>[
      'Exercise 5',
      'Closed Eyes',
      'No Motion',
    ],
  ),
  const Routines(
    assetName: 'assets/6.png',
    description: const <String>[
      'Exercise 6',
      'Eyes Open Wide',
      'No Motion',
    ],
  )
];

class RoutinesItem extends StatelessWidget {
  RoutinesItem({ Key key, @required this.destination, this.shape });

  static const double height = 366.0;
  final Routines destination;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    return new SafeArea(
      top: false,
      bottom: false,
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        height: height,
        child: new Card(
          shape: shape,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // photo and title
              new SizedBox(
                height: 184.0,
                child: new Stack(
                  children: <Widget>[
                    new Positioned.fill(
                      child: new Image.asset(
                        destination.assetName,
                        fit: BoxFit.cover,
                      ),
                    ),
                    new Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      right: 16.0,
                      child: new FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ],
                ),
              ),
              // description and share/explore buttons
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: new DefaultTextStyle(
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: descriptionStyle,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // three line descriptionconst
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: new Text(
                            destination.description[0],
                            style: descriptionStyle.copyWith(color: Colors.black54),
                          ),
                        ),
                        new Text(destination.description[1]),
                        new Text(destination.description[2]),
                      ],
                    ),
                  ),
                ),
              ),
              // share, explore buttons
              new ButtonTheme.bar(
                child: new ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new FlatButton(
                      child: const Text('SHARE'),
                      textColor: Colors.amber.shade500,
                      onPressed: () { /* do nothing */ },
                    ),
                    new FlatButton(
                      child: const Text('EXPLORE'),
                      textColor: Colors.amber.shade500,
                      onPressed: () { /* do nothing */ },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Exercises extends StatefulWidget {
  static const String routeName = '/material/cards';

  @override
  _ExercisesState createState() => new _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  ShapeBorder _shape;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('iDetect Exercises'),
      ),
      body: new ListView(
        itemExtent: RoutinesItem.height,
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        children: destinations.map((Routines destination) {
          return new Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: new RoutinesItem(
              destination: destination,
              shape: _shape,
            ),
          );
        }).toList()
      )
    );
  }
}
