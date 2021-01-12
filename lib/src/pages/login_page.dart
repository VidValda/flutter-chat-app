import 'package:flutter/material.dart';
import 'package:messages_app/src/helpers/mostrat_alerta.dart';
import 'package:messages_app/src/services/auth_service.dart';
import 'package:messages_app/src/services/socket_service.dart';
import 'package:messages_app/src/widgets/blue_button.dart';

import 'package:messages_app/src/widgets/custom_input.dart';
import 'package:messages_app/src/widgets/logo.dart';
import 'package:messages_app/src/widgets/labels.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Logo(
                  titulo: "Messenger",
                ),
                _Form(),
                Labels(
                  ruta: "register",
                  topText: "Doesn't have an account?",
                  bottomText: "Create one now!",
                ),
                Text(
                  "Terms and conditions of use",
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            text: "Email",
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            text: "Password",
            textController: passCtrl,
            isPassword: true,
          ),
          BlueButton(
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                    );

                    if (loginOk.ok) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, "usuarios");
                    } else {
                      // Mpstrar alerta
                      mostrarAlerta(
                        context,
                        "Login incorrecto",
                        loginOk.errores == null
                            ? loginOk.msg
                            : "${loginOk.errores.email.msg}\n${loginOk.errores.password.msg}",
                      );
                    }
                  },
            text: "Login",
          )
        ],
      ),
    );
  }
}
