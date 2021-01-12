import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages_app/src/services/auth_service.dart';
import 'package:messages_app/src/services/chat_service.dart';
import 'package:messages_app/src/services/socket_service.dart';
import 'package:messages_app/src/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  List<ChatBubble> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on("mensaje-personal", _listenMessage);
    _recargarMensajes();
  }

  void _listenMessage(dynamic data) {
    ChatBubble message = ChatBubble(
      uidLocal: authService.user.uid,
      uid: data["from"],
      message: data["msg"],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 200,
        ),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

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
              child: Text(chatService.userDest.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 15)),
              backgroundColor: Colors.blue[100],
              // maxRadius: 15},
            ),
            SizedBox(height: 3),
            Text(
              chatService.userDest.nombre,
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
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatBubble(
      uidLocal: authService.user.uid,
      uid: authService.user.uid,
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
    this.socketService.emit("mensaje-personal", {
      "from": authService.user.uid,
      "to": chatService.userDest.uid,
      "msg": text
    });
  }

  @override
  void dispose() {
    _messages.forEach((m) {
      m.animationController.dispose();
    });
    this.socketService.socket.off("mensaje-personal");
    super.dispose();
  }

  Future<void> _recargarMensajes() async {
    final messageList = await chatService.getChat(chatService.userDest.uid);

    final List<ChatBubble> bubbleList = messageList.map((mensaje) {
      return ChatBubble(
        uidLocal: authService.user.uid,
        uid: mensaje.from,
        message: mensaje.msg,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 200),
        ),
      );
    }).toList();
    bubbleList.forEach((bubble) {
      bubble.animationController.forward();
    });
    this._messages.addAll(bubbleList);
    setState(() {});
  }
}
