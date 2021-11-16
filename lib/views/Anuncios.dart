// ignore_for_file: file_names
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/util/Configuracoes.dart';
import 'package:olx_clone/views/widgets/ItemAnuncio.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({Key? key}) : super(key: key);

  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  List<String> itensMenu = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = List.empty();
  List<DropdownMenuItem<String>> _listaItensDropCategorias = List.empty();

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  @override
  void initState() {
    super.initState();

    _carregarItensDropDown();
    _verificarUsuarioLogado();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: [
          Text("Carragando anuncios"),
          CircularProgressIndicator(),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                      child: Center(
                    child: DropdownButton(
                      iconEnabledColor: const Color(0xff9c27b0),
                      value: _itemSelecionadoEstado,
                      items: _listaItensDropEstados,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                      onChanged: (estado) {
                        setState(() {
                          _itemSelecionadoEstado = estado as String?;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  )),
                ),
                Container(
                  color: Colors.grey[200],
                  width: 2,
                  height: 60,
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                      child: Center(
                    child: DropdownButton(
                      iconEnabledColor: const Color(0xff9c27b0),
                      value: _itemSelecionadoCategoria,
                      items: _listaItensDropCategorias,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                      onChanged: (categoria) {
                        setState(() {
                          _itemSelecionadoCategoria = categoria as String?;
                          _filtrarAnuncios();
                        });
                      },
                    ),
                  )),
                )
              ],
            ),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return carregandoDados;
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot? querySnapshot =
                        snapshot.data as QuerySnapshot;

                    if (querySnapshot.docs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(25),
                        child: const Text(
                          "Nenhum anúncio! :( ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (_, indice) {
                            List<DocumentSnapshot> anuncios =
                                querySnapshot.docs.toList();
                            DocumentSnapshot documentSnapshot =
                                anuncios[indice];
                            Anuncio anuncio =
                                Anuncio.fromDocumentSnapshot(documentSnapshot);

                            return ItemAnuncio(
                              anuncio: anuncio,
                              onTapItem: () {
                                Navigator.pushNamed(
                                  context,
                                  "/detalhes-anuncio",
                                  arguments: anuncio,
                                );
                              },
                            );
                          }),
                    );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("anuncios").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>?> _filtrarAnuncios() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    //Stream<QuerySnapshot> stream = db.collection("anuncios").snapshots();

    Query query = db.collection("anuncios");

    if (_itemSelecionadoEstado != null) {
      query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }

    if (_itemSelecionadoCategoria != null) {
      query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
    }

    Stream<QuerySnapshot> stream = query.snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _carregarItensDropDown() {
    // Carregar itens Categoria
    _listaItensDropCategorias = Configuracoes.getCategorias();

    // Carregar itens Estados
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Meus Anúncios":
        Navigator.pushNamed(context, "/meus-anuncios");
        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushNamed(context, "/login");
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      itensMenu = [
        "Entrar / Cadastrar",
      ];
    } else {
      itensMenu = [
        "Meus Anúncios",
        "Deslogar",
      ];
    }
  }
}
