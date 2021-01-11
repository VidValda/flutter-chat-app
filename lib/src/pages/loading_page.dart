import 'package:flutter/material.dart';
import 'package:messages_app/src/pages/login_page.dart';
import 'package:messages_app/src/pages/usuarios_page.dart';
import 'package:messages_app/src/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final realUser = await authService.isLoggedIn();
    if (realUser) {
      //TODO: conectar al socket server
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: UsuariosPage(),
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: LoginPage(),
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    }
  }
}
