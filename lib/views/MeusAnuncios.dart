// ignore_for_file: file_names
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/views/widgets/ItemAnuncio.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({Key? key}) : super(key: key);

  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String? _idUsuarioLogado;

  @override
  void initState() {
    super.initState();

    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: const [
          Text("Carregando anúncios"),
          CircularProgressIndicator(),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff7b1fa2),
        title: const Text(
          "Meus Anúncios",
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff7b1fa2),
        icon: const Icon(Icons.add),
        label: const Text("Adicionar"),
        onPressed: () {
          Navigator.pushNamed(context, "/novo-anuncio");
        },
        foregroundColor: Colors.white,
        //child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
            case ConnectionState.active:
            case ConnectionState.done:
              // Exibe mensagem de erro
              if (snapshot.hasError) {
                return const Text("Erro ao carregar os dados");
              }

              QuerySnapshot? querySnapshot = snapshot.data as QuerySnapshot;

              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, indice) {
                    List<DocumentSnapshot> anuncios =
                        querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = anuncios[indice];
                    Anuncio anuncio =
                        Anuncio.fromDocumentSnapshot(documentSnapshot);

                    return ItemAnuncio(
                      anuncio: anuncio,
                      onPressedRemover: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirmar"),
                              content: const Text(
                                  "Deseja realmente excluir o anúncio?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _removerAnuncio(anuncio.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Remover",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  });
          }
        },
      ),
    );
  }

  _removerAnuncio(String idAnuncio) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .doc(idAnuncio)
        .delete()
        .then((_) {
      db.collection("anuncios").doc(idAnuncio).delete();
    });
  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerAnuncios() async {
    await _recuperarDadosUsuarioLogado();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _recuperarDadosUsuarioLogado() async {
    // salvar anuncio no Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser!;
    _idUsuarioLogado = usuarioLogado.uid;
  }
}
