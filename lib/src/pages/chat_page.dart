import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages_app/src/widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  List<ChatBubble> _messages = [];

  bool _isWriting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              child: Text("Te", style: TextStyle(fontSize: 15)),
              backgroundColor: Colors.blue[100],
              // maxRadius: 15},
            ),
            SizedBox(height: 3),
            Text(
              "Test 1 Nombre",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
              ),
            ),
            Divider(height: 1),
            Container(
              color: Colors.white,
              height: 60,
              width: double.infinity,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {
                    _isWriting = (value.trim().length > 0);
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: "Escribir mensaje",
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isAndroid
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send_sharp),
                          onPressed: _isWriting
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    )
                  : CupertinoButton(
                      child: Text("Send"),
                      onPressed: _isWriting
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;
    print(text);
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatBubble(
      uid: "123",
      message: text,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    //off del socket
    _messages.forEach((m) {
      m.animationController.dispose();
    });
    super.dispose();
  }
}
