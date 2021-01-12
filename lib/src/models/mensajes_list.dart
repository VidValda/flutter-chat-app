// To parse this JSON data, do
//
//     final mensajesList = mensajesListFromJson(jsonString);

import 'dart:convert';

MensajesList mensajesListFromJson(String str) =>
    MensajesList.fromJson(json.decode(str));

String mensajesListToJson(MensajesList data) => json.encode(data.toJson());

class MensajesList {
  MensajesList({
    this.ok,
    this.mensajes,
  });

  bool ok;
  List<Mensaje> mensajes;

  factory MensajesList.fromJson(Map<String, dynamic> json) => MensajesList(
        ok: json["ok"],
        mensajes: List<Mensaje>.from(
            json["mensajes"].map((x) => Mensaje.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
      };
}

class Mensaje {
  Mensaje({
    this.from,
    this.to,
    this.msg,
    this.createdAt,
    this.updatedAt,
  });

  String from;
  String to;
  String msg;
  DateTime createdAt;
  DateTime updatedAt;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        from: json["from"],
        to: json["to"],
        msg: json["msg"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "msg": msg,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
