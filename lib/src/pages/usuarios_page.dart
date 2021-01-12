import 'package:flutter/material.dart';
import 'package:messages_app/src/services/chat_service.dart';
import 'package:messages_app/src/services/socket_service.dart';
import 'package:messages_app/src/services/usuarios_service.dart';
import 'package:provider/provider.dart';
import 'package:messages_app/src/services/auth_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:messages_app/src/models/user.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final userService = new UsersService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<User> users = [];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          user.nombre,
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black54,
          ),
          onPressed: () async {
            socketService.disconnect();
            await AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, "login");
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[400])
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400],
        ),
        controller: _refreshController,
        child: _listUsers(users),
        enablePullDown: true,
      ),
    );
  }

  void _cargarUsuarios() async {
    this.users = await userService.getUsers();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  Widget _listUsers(List<User> users) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _UserTile(user: users[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: users.length,
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.nombre),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(user.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userDest = user;
        Navigator.pushNamed(context, "chat");
      },
    );
  }
}
