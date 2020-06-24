import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:prueba_gbp/src/pages/home_page.dart';
 
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox("activity_box");
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba GPB',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/home' : (_) => HomePage(),
      },
    );
  }
}