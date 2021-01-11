import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:messages_app/src/global/envorironment.dart';
import 'package:messages_app/src/models/login_resp.dart';
import 'package:messages_app/src/models/user.dart';

class AuthService with ChangeNotifier {
  User _user;
  bool _autenticando = false;

  final _storage = FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool value) {
    this._autenticando = value;
    notifyListeners();
  }

  User get user => this._user;
  set user(User value) {
    this._user = value;
    notifyListeners();
  }
  //getter del token de forma statica

  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: "token");
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: "token");
  }

  Future<LoginResp> login(String email, String password) async {
    this.autenticando = true;
    LoginResp loginResp;
    final data = {
      "email": email,
      "password": password,
    };

    try {
      final resp = await http.post(
        "${Environments.apiUrl}/login",
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      loginResp = loginRespFromJson(resp.body);
      if (resp.statusCode == 200) {
        this.user = loginResp.user;
        await this._saveToken(loginResp.token);
      }
    } catch (e) {
      print(e);
    }
    this.autenticando = false;
    return loginResp;
  }

  Future<LoginResp> register(String name, String email, String password) async {
    this.autenticando = true;
    LoginResp loginResp;
    final data = {
      "nombre": name,
      "email": email,
      "password": password,
    };

    try {
      final resp = await http.post(
        "${Environments.apiUrl}/login/new",
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      loginResp = loginRespFromJson(resp.body);
      if (resp.statusCode == 200) {
        this.user = loginResp.user;
        await this._saveToken(loginResp.token);
      }
    } catch (e) {
      print(e);
    }
    this.autenticando = false;
    return loginResp;
  }

  Future _saveToken(String token) async {
    await _storage.write(
      key: "token",
      value: token,
    );
  }

  Future logout() async {
    await _storage.delete(key: "token");
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: "token");
    try {
      final resp = await http.get(
        "${Environments.apiUrl}/login/renew",
        headers: {
          "Content-Type": "application/json",
          "x-token": token,
        },
      );
      if (resp.statusCode == 200) {
        final loginResp = loginRespFromJson(resp.body);
        this.user = loginResp.user;
        print(resp.body);
        await this._saveToken(loginResp.token);
        return true;
      } else {
        this.logout();
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
