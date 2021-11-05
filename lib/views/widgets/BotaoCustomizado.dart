// ignore_for_file: file_names
import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  const BotaoCustomizado({
    required this.texto,
    this.corTexto = Colors.white,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String texto;
  final Color corTexto;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Text(
          texto,
          style: TextStyle(
            color: corTexto,
            fontSize: 20,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        primary: const Color(0xff9c27b0),
      ),
      onPressed: onPressed,
    );
  }
}
