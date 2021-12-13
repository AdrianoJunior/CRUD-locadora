import 'dart:convert' as convert;

class Carro {
  String? id;
  String? modelo;
  String? placa;
  String? fabricante;
  String? tipo;
  String? ano;
  bool? reservado;
  String? urlFoto;

  Carro(
      {this.id,
      this.modelo,
      this.urlFoto,
      this.placa,
      this.fabricante,
      this.tipo,
      this.ano,
      this.reservado});

  Carro.fromMap(Map<String, dynamic>? json) {
    id = json!['id'];
    modelo = json['modelo'];
    placa = json['placa'];
    fabricante = json['fabricante'];
    tipo = json['tipo'];
    ano = json['ano'];
    reservado = json['reservado'];
    urlFoto = json['urlFoto'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['modelo'] = modelo;
    data['placa'] = placa;
    data['fabricante'] = fabricante;
    data['tipo'] = tipo;
    data['ano'] = ano;
    data['reservado'] = reservado;
    data['urlFoto'] = urlFoto;
    return data;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }

  @override
  String toString() {
    return 'Carro{ID: $id, placa: $placa, modelo: $modelo, tipo: $tipo, fabricante: $fabricante, ano: $ano, reservado: $reservado}';
  }
}
