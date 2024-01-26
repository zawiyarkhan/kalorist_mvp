import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kalorist_mvp/consts.dart';

class Home extends StatefulWidget {
  String id;
  String? email;
  Home({super.key, required this.email, required this.id});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _openAI = OpenAI.instance.build(
      token: dotenv.env["OPEN_AI_KEY"],
      baseOption: HttpSetup(
        receiveTimeout: Duration(seconds: 5),
      ),
      enableLog: true);

  List<ChatMessage> messages = <ChatMessage>[];

  final ChatUser _gptChatUser = ChatUser(
    id: "2",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kal Coach"),
      ),
      body: DashChat(
        currentUser: ChatUser(id: widget.id, firstName: widget.email),
        onSend: getResponse,
        messages: messages,
      ),
    );
  }

  Future<void> getResponse(ChatMessage m) async {
    setState(() {
      messages.insert(0, m);
    });
    List<Messages> _messageHistory = messages
        .map((m) => m.user.id == widget.id
            ? Messages(role: Role.user, content: m.text)
            : Messages(role: Role.assistant, content: m.text))
        .toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: _messageHistory,
      maxToken: 200,
    );

    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          messages.insert(
              0,
              ChatMessage(
                  user: _gptChatUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content));
        });
      }
    }
  }
}
