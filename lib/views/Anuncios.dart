// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/util/Configuracoes.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({Key? key}) : super(key: key);

  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  List<String> itensMenu = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = List.empty();
  List<DropdownMenuItem<String>> _listaItensDropCategorias = List.empty();
  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  @override
  void initState() {
    super.initState();

    _carregarItensDropDown();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
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
                        });
                      },
                    ),
                  )),
                )
              ],
            ),
          ],
        ),
      ),
    );
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
