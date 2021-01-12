import 'dart:io';

class Environments {
  static String apiUrl = Platform.isAndroid
      ? "https://chat-app-server-flutter.herokuapp.com/api"
      : "https://chat-app-server-flutter.herokuapp.com/api";
  static String socketUrl = Platform.isAndroid
      ? "https://chat-app-server-flutter.herokuapp.com"
      : "https://chat-app-server-flutter.herokuapp.com";
}
