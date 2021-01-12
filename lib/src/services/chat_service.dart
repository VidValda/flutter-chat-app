import 'package:flutter/material.dart';
import 'package:messages_app/src/global/envorironment.dart';
import 'package:messages_app/src/models/mensajes_list.dart';
import 'package:messages_app/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:messages_app/src/services/auth_service.dart';

class ChatService with ChangeNotifier {
  User userDest;
  Future<List<Mensaje>> getChat(String userID) async {
    final resp = await http.get(
      "${Environments.apiUrl}/mensajes/$userID",
      headers: {
        "Content-Type": "application/json",
        "x-token": await AuthService.getToken(),
      },
    );
    final MensajesList messageList = mensajesListFromJson(resp.body);
    return messageList.mensajes;
  }
}
