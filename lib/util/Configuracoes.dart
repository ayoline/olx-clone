// ignore_for_file: file_names

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes {
  static List<DropdownMenuItem<String>> getEstados() {
    List<DropdownMenuItem<String>> listaItensDropEstados = [];

    // Carregar itens Categoria
    listaItensDropEstados = listaItensDropEstados.toList();

    listaItensDropEstados.add(const DropdownMenuItem(
      child: Text(
        "Região",
        style: TextStyle(
          color: Color(0xff9c27b0),
        ),
      ),
      value: null,
    ));

    listaItensDropEstados = listaItensDropEstados.toList();
    for (var estado in Estados.listaEstadosSigla) {
      listaItensDropEstados.add(
        DropdownMenuItem(
          child: Text(estado),
          value: estado,
        ),
      );
    }

    return listaItensDropEstados;
  }

  static List<DropdownMenuItem<String>> getCategorias() {
    List<DropdownMenuItem<String>> itensDropCategorias = [];

    // Carregar itens Categoria
    itensDropCategorias = itensDropCategorias.toList();

    itensDropCategorias.add(const DropdownMenuItem(
      child: Text(
        "Categoria",
        style: TextStyle(
          color: Color(0xff9c27b0),
        ),
      ),
      value: null,
    ));

    itensDropCategorias.add(const DropdownMenuItem(
      child: Text("Automóvel"),
      value: "auto",
    ));

    itensDropCategorias.add(const DropdownMenuItem(
      child: Text("Imóvel"),
      value: "imovel",
    ));

    itensDropCategorias.add(const DropdownMenuItem(
      child: Text("Eletrônicos"),
      value: "eletro",
    ));

    itensDropCategorias.add(const DropdownMenuItem(
      child: Text("Moda"),
      value: "moda",
    ));

    itensDropCategorias.add(const DropdownMenuItem(
      child: Text("Esportes"),
      value: "esportes",
    ));

    return itensDropCategorias;
  }
}
