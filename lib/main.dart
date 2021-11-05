import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:olx_clone/RouteGenerator.dart';
import 'package:olx_clone/views/Anuncios.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: const Color(0xff9c27b0),
);
void main() async {
// inicializar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: temaPadrao,
    title: "OLX",
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    home: const Anuncios(),
  ));
}
