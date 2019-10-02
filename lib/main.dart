import 'package:flutter/material.dart';
import 'package:expencetracker/UIpages/HomeUI.dart';
import 'package:expencetracker/UIpages/expenceUI.dart';

void main() {
  runApp(new MaterialApp(routes: <String, WidgetBuilder>{
    '/': (context) => new HomePageUI(),
    "/ExpenceEntry": (context) => new ExpenceEntryUI(null)
  }
  ,debugShowCheckedModeBanner: false,
  theme: ThemeData(
    primaryColor: Colors.orange,
    accentColor: Colors.orangeAccent,
    //brightness: Brightness.dark
  ),
  ));
}
