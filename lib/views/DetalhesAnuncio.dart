// ignore_for_file: file_names, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:olx_clone/main.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(
        backgroundColor: const Color(0xff7b1fa2),
      ),
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
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "R\$ ${_anuncio!.preco}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: temaPadrao.primaryColor,
                      ),
                    ),
                    Text(
                      "${_anuncio!.titulo}",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    const Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_anuncio!.descricao}",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    const Text(
                      "Contato",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 66),
                      child: Text(
                        "${_anuncio!.telefone}",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //botão ligar
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              child: Container(
                child: const Text(
                  "Ligar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: temaPadrao.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onTap: () {
                _ligarTelefone(_anuncio!.telefone);
              },
            ),
          ),
        ],
      ),
    );
  }

  _ligarTelefone(String telefone) async {
    if (await canLaunch("tel:$telefone")) {
      await launch("tel:$telefone");
    }
  }
}
