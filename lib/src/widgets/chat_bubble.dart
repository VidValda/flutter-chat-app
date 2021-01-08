import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String uid;
  final String message;
  final AnimationController animationController;
  const ChatBubble({
    @required this.uid,
    @required this.message,
    @required this.animationController,
  });
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        child: Container(
          child: this.uid == "123" ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 8, left: 50, right: 6),
        padding: EdgeInsets.all(10),
        child: Text(
          this.message,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 8, left: 6, right: 50),
        padding: EdgeInsets.all(10),
        child: Text(
          this.message,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xFFE4E5E8),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
