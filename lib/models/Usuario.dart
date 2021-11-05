// ignore_for_file: unnecessary_this, file_names

class Usuario {
  String? _idUsuario;
  String? _nome;
  String? _email;
  String? _senha;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUsuario": idUsuario,
      "nome": nome,
      "email": email,
    };

    return map;
  }

  get idUsuario => this._idUsuario;

  set idUsuario(value) => this._idUsuario = value;

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get email => this._email;

  set email(value) => this._email = value;

  get senha => this._senha;

  set senha(value) => this._senha = value;
}
