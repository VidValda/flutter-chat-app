import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messages_app/src/services/chat_service.dart';
import 'package:provider/provider.dart';

import 'package:messages_app/src/routes/routes.dart';
import 'package:messages_app/src/services/auth_service.dart';
import 'package:messages_app/src/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        initialRoute: "loading",
        routes: appRoutes,
      ),
    );
  }
}
