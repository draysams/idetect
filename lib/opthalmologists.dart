// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Places {
  const Places({
    this.assetName,
    this.title,
    this.description,
  });

  final String assetName;
  final String title;
  final List<String> description;

  bool get isValid => assetName != null && title != null && description?.length == 3;
}

final List<Places> destinations = <Places>[
  const Places(
    assetName: 'assets/emmanuel.jpg',
    description: const <String>[
      'Emmanuel Eye Medical Center',
      '030 250 0578',
      'http://www.lukemissions.org',
    ],
  ),
  const Places(
    assetName: 'assets/vanj.jpg',
    description: const <String>[
      'Van J Eye Care',
      '020 813 0301',
      'http://www.vanjeyecare.org',
    ],
  ),
  const Places(
    assetName: 'assets/interstar.jpg',
    description: const <String>[
      'Inter-Star Eye Clinic And Laser Center',
      '030 278 3832',
      'http://www.interstareyeclinic.com',
    ],
  ),
  const Places(
    assetName: 'assets/thirdeye.jpg',
    description: const <String>[
      'Third Eyecare And Vision Centre',
      '054 328 7008',
      'http://www.thirdeyecare.com',
    ],
  ),
  const Places(
    assetName: 'assets/agarwal.jpg',
    description: const <String>[
      'Dr. Agarwals Eye Hospital, Accra',
      '050 301 9311',
      'http://www.dragarwal.com',
    ],
  )
];

class PlacesItem extends StatelessWidget {
  PlacesItem({ Key key, @required this.destination, this.shape });

  static const double height = 366.0;
  final Places destination;
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


class Opthalmologists extends StatefulWidget {
  static const String routeName = '/material/cards';

  @override
  _OpthalmologistsState createState() => new _OpthalmologistsState();
}

class _OpthalmologistsState extends State<Opthalmologists> {
  ShapeBorder _shape;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Eyecare Centres'),
      ),
      body: new ListView(
        itemExtent: PlacesItem.height,
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        children: destinations.map((Places destination) {
          return new Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: new PlacesItem(
              destination: destination,
              shape: _shape,
            ),
          );
        }).toList()
      )
    );
  }
}
