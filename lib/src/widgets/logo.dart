import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;

  const Logo({
    Key key,
    @required this.titulo,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // color: Colors.red,
      child: Column(
        children: [
          Image.asset("assets/tag-logo.png", height: 115),
          SizedBox(height: 20),
          Text(titulo, style: TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}
