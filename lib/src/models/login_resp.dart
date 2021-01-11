import 'dart:convert';

import 'package:messages_app/src/models/user.dart';

LoginResp loginRespFromJson(String str) => LoginResp.fromJson(json.decode(str));

class LoginResp {
  LoginResp({
    this.ok,
    this.user,
    this.token,
    this.msg,
    this.errores,
  });

  bool ok;
  User user;
  String token;
  String msg;
  Errores errores;

  factory LoginResp.fromJson(Map<String, dynamic> json) => LoginResp(
        ok: json.containsKey("ok") ? json["ok"] : null,
        user: json.containsKey("user") ? User.fromJson(json["user"]) : User(),
        token: json.containsKey("token") ? json["token"] : null,
        msg: json.containsKey("msg") ? json["msg"] : null,
        errores: json.containsKey("errores")
            ? Errores.fromJson(json["errores"])
            : null,
      );
}

class Errores {
  Errores({
    this.email,
    this.password,
    this.name,
  });

  ErrorLog email;
  ErrorLog password;
  ErrorLog name;

  factory Errores.fromJson(Map<String, dynamic> json) => Errores(
        email: json.containsKey("email")
            ? ErrorLog.fromJson(json["email"])
            : ErrorLog(msg: ""),
        password: json.containsKey("password")
            ? ErrorLog.fromJson(json["password"])
            : ErrorLog(msg: ""),
        name: json.containsKey("name")
            ? ErrorLog.fromJson(json["name"])
            : ErrorLog(msg: ""),
      );
}

class ErrorLog {
  ErrorLog({
    this.value,
    this.msg,
    this.param,
    this.location,
  });

  String value;
  String msg;
  String param;
  String location;

  factory ErrorLog.fromJson(Map<String, dynamic> json) => ErrorLog(
        value: json.containsKey("value") ? json["value"] : null,
        msg: json.containsKey("msg") ? json["msg"] : null,
        param: json.containsKey("param") ? json["param"] : null,
        location: json.containsKey("location") ? json["location"] : null,
      );
}
