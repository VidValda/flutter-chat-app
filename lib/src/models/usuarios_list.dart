import 'dart:convert';

import 'package:messages_app/src/models/user.dart';

UsuariosList usuariosListFromJson(String str) =>
    UsuariosList.fromJson(json.decode(str));

String usuariosListToJson(UsuariosList data) => json.encode(data.toJson());

class UsuariosList {
  UsuariosList({
    this.ok,
    this.users,
  });

  bool ok;
  List<User> users;

  factory UsuariosList.fromJson(Map<String, dynamic> json) => UsuariosList(
        ok: json["ok"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}
