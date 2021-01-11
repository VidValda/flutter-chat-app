import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

mostrarAlerta(BuildContext context, String title, String subtitle) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? ""),
        content: Text(subtitle ?? ""),
        actions: [
          MaterialButton(
            child: Text("Ok"),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(subtitle ?? ""),
        actions: [
          CupertinoDialogAction(
            child: Text("Ok"),
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
