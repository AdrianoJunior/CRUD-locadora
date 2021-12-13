import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locadora/utils/prefs.dart';

class Usuario {
  String? nome;
  String? email;
  String? senha;
  String? id;
  String? endereco;
  String? numeroCasa;
  String? telefone;
  Timestamp? dataNascimento;

  Usuario({
    this.nome,
    this.id,
    this.endereco,
    this.numeroCasa,
    this.telefone,
    this.dataNascimento,
    this.email,
    this.senha,
  });

  static Usuario fromMap(Map<String, dynamic> user) => Usuario(
        nome: user['nome'],
        id: user['id'],
        endereco: user['endereco'],
        numeroCasa: user['numeroCasa'],
        telefone: user['telefone'],
        dataNascimento: user['dataNascimento'],
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = nome;
    data['id'] = id;
    data['endereco'] = endereco;
    data['numeroCasa'] = numeroCasa;
    data['telefone'] = telefone;
    data['dataNascimento'] = dataNascimento;
    return data;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }

  static void clear() {
    Prefs.setString("user.prefs", "");
  }

  /*void save() {
    // Map map = toMap();

    final Map<String, dynamic> userData = new Map<String, dynamic>();
    // userData['nome'] = this.nome;
    // userData['id'] = this.id;
    userData['email'] = this.email;
    userData['senha'] = this.senha;

    String json = convert.json.encode(userData);
    Prefs.setString("user.prefs", json);
  }*/

  /*static Future<Usuario?> get() async {
    String json = await Prefs.getString("user.prefs");

    if (json.isEmpty) {
      return null;
    }
    Map<String, dynamic> map = convert.json.decode(json);

    Usuario user = Usuario.fromMap(map);

    return user;
  }*/

  @override
  String toString() {
    return 'Usuario{id: $id, nome: $nome, Data: $dataNascimento}';
  }
}
