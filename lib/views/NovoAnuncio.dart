// ignore_for_file: file_names
import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/util/Configuracoes.dart';
import 'package:olx_clone/views/widgets/BotaoCustomizado.dart';
import 'package:olx_clone/views/widgets/InputCustomizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  Anuncio? _anuncio;
  BuildContext? _dialogContext;

  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  ImagePicker imagePicker = ImagePicker();

  List<File> _listaImagens = List.empty();
  List<DropdownMenuItem<String>> _listaItensDropEstados = List.empty();
  List<DropdownMenuItem<String>> _listaItensDropCategorias = List.empty();

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();

    _anuncio = Anuncio.gerarId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff7b1fa2),
        title: const Text(
          "Novo Anúncio",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                        .valido(imagens.toString());
                    /*
                    if (imagens!.isEmpty) {
                      return "Necesário selecionar uma imagem!";
                    }
                    return null;*/
                  },
                  builder: (state) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listaImagens.length + 1,
                            itemBuilder: (context, indice) {
                              if (indice == _listaImagens.length) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selecionarImagemGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (_listaImagens.isNotEmpty) {}
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.file(_listaImagens[indice]),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _listaImagens
                                                      .removeAt(indice);
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              child: const Text(
                                                "Excluir",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        FileImage(_listaImagens[indice]),
                                    child: Container(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.4),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEstado,
                          hint: const Text("Estados"),
                          onSaved: (estado) {
                            _anuncio!.estado = estado;
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          items: _listaItensDropEstados,
                          validator: (String? valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoEstado = valor.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoCategoria,
                          hint: const Text("Categorias"),
                          onSaved: (categoria) {
                            _anuncio!.categoria = categoria;
                          },
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          items: _listaItensDropCategorias,
                          validator: (String? valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo Obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoCategoria = valor.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    hint: "Título",
                    onSaved: (titulo) {
                      _anuncio!.titulo = titulo;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Preço",
                    onSaved: (preco) {
                      _anuncio!.preco = preco;
                    },
                    type: TextInputType.number,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Telefone",
                    onSaved: (telefone) {
                      _anuncio!.telefone = telefone;
                    },
                    type: TextInputType.phone,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .valido(valor);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Descrição(200 caracteres)",
                    onSaved: (descricao) {
                      _anuncio!.descricao = descricao;
                    },
                    maxLines: 10,
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor);
                    },
                  ),
                ),
                BotaoCustomizado(
                  texto: "Cadastrar anúncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Salvar campos
                      _formKey.currentState!.save();

                      // Configura Dialog context
                      _dialogContext = context;

                      // Salvar anuncio
                      _salvarAnuncio();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _abrirDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text("Salvando anúncio...")
            ],
          ),
        );
      },
    );
  }

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext!);
    // upload das imagens no storage
    await _uploadImagens();

    // salvar anuncio no Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser!;
    String idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("meus_anuncios")
        .doc(idUsuarioLogado)
        .collection("anuncios")
        .doc(_anuncio!.id)
        .set(_anuncio!.toMap());

    // Salvar anúncio público
    db
        .collection("anuncios")
        .doc(_anuncio!.id)
        .set(_anuncio!.toMap())
        .then((_) {
      Navigator.pop(_dialogContext!);
      Navigator.pop(context);
    });
  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      Reference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_anuncio!.id)
          .child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem);
      TaskSnapshot taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio!.fotos.add(url);
    }
  }

  _carregarItensDropDown() {
    // Carregar itens Categoria
    _listaItensDropCategorias = Configuracoes.getCategorias();

    // Carregar itens Estados
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  _selecionarImagemGaleria() async {
    File imagemSelecionada;
    // Usado somente para não ocorrer um erro relacionado a lista.
    _listaImagens = _listaImagens.toList();

    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    imagemSelecionada = File(pickedFile!.path);

    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }
}
