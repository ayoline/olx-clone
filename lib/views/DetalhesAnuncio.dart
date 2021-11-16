// ignore_for_file: file_names, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetalhesAnuncio extends StatefulWidget {
  //const DetalhesAnuncio(String? args, {Key? key}) : super(key: key);

  Anuncio anuncio;
  DetalhesAnuncio(this.anuncio);

  @override
  _DetalhesAnuncioState createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  Anuncio? _anuncio;

  List<Widget>? _getListaImagens() {
    List<String> listaUrlImagens = _anuncio!.fotos;
    return listaUrlImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image:
              DecorationImage(image: NetworkImage(url), fit: BoxFit.fitWidth),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    _anuncio = widget.anuncio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          //conteudos
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: Container(
                  child: CarouselSlider(
                    items: _getListaImagens(),
                    options: CarouselOptions(),
                  ),
                ),
              )
            ],
          )

          //botão ligar
        ],
      ),
    );
  }
}
