import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.online,
    this.nombre,
    this.email,
    this.uid,
  });

  bool online;
  String nombre;
  String email;
  String uid;

  factory User.fromJson(Map<String, dynamic> json) => User(
        online: json.containsKey("online") ? json["online"] : null,
        nombre: json.containsKey("nombre") ? json["nombre"] : null,
        email: json.containsKey("email") ? json["email"] : null,
        uid: json.containsKey("uid") ? json["uid"] : null,
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "nombre": nombre,
        "email": email,
        "uid": uid,
      };
}
