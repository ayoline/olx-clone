// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/views/Anuncios.dart';
import 'package:olx_clone/views/Login.dart';
import 'package:olx_clone/views/MeusAnuncios.dart';
import 'package:olx_clone/views/NovoAnuncio.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as String?;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => const Anuncios(),
        );
      case "/login":
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case "/meus-anuncios":
        return MaterialPageRoute(
          builder: (_) => const MeusAnuncios(),
        );
      case "/novo-anuncio":
        return MaterialPageRoute(
          builder: (_) => const NovoAnuncio(),
        );
      default:
        _erroRota();
    }
    return _erroRota();
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Tela não encontrada"),
          ),
          body: const Center(
            child: Text("Tela não encontrada"),
          ),
        );
      },
    );
  }
}
