import 'package:http/http.dart' as http;
import 'package:messages_app/src/global/envorironment.dart';
import 'package:messages_app/src/models/user.dart';
import 'package:messages_app/src/models/usuarios_list.dart';
import 'package:messages_app/src/services/auth_service.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final resp = await http.get(
        "${Environments.apiUrl}/usuarios",
        headers: {
          "Content-Type": "application/json",
          "x-token": await AuthService.getToken(),
        },
      );
      final usuariosList = usuariosListFromJson(resp.body);
      return usuariosList.users;
    } catch (e) {
      return [];
    }
  }
}
