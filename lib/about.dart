// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class About extends StatefulWidget {
  static const String routeName = '/material/cards';

  @override
  _AboutState createState() => new _AboutState();
}

class _AboutState extends State<About> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('About'),
      ),
      body: new Center(
        child: new Text('© iDetect 2017'),
      )
    );
  }
}
