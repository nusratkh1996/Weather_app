import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'weather.dart';

void main() => runApp(new MaterialApp(
    title: 'Weather App',
    theme: ThemeData(primaryColor: Colors.amber),
    debugShowCheckedModeBanner: false,
    home: homePage()));
