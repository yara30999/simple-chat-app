import 'package:flutter/material.dart';
import 'package:flach_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final _firestore = FirebaseFirestore.instance;  // we write it above , while we fator the code.
  final _auth = FirebaseAuth.instance;
  // late User signedInUser;// we white it above
  String? messageText;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

///////////////////////   not used //////////////////////
//this function gets data from the firestore if the user click on button
// and it is not agood way for a chat app we need to push single message to the screen ,
// without clicking on a button .(((  we will using streams  )))
  void getMessages() async {
    final messages = await _firestore
        .collection('messages')
        .get(); // returs ((((  future snapshot.  ))))
    for (var message in messages.docs) {
      print(message.data());
    }
  }

///////////////////////   not used //////////////////////
//this function open a stream of data from the firestore if the user click on button
//whenever a new message typed it is render all the messages without click any buttons.
  void messagesStream() async {
    // this line returns(((  stream snapshot. ))) ===> _firestore.collection('messages').snapshots()
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
                //messagesStream();
                //getMessages();
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessageStreamBuilder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,

                      onChanged: (value) {
                        //Do something with the user input.

                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': signedInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      }); //'time':FieldValue.serverTimestamp()  or this  DateTime.now()
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
            .orderBy('time',descending: false)
            .snapshots(), //.orderBy('time')
        builder: (context, snapshot) {
          List<MessageLine> meassageWidget = [];

          if (!snapshot.hasData) {
            return SizedBox(
              width: 100.0,
              height: 300.0,
              child: Column(
                children: const [
                  CircularProgressIndicator(backgroundColor: Colors.lightBlue),
                  Text(
                    'there is no history in this chat',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            );
          }
          final messages = snapshot.data!.docs.reversed; //list of docs
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = signedInUser.email;

            meassageWidget.add(MessageLine(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender ? true : false,
            ));
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              children: meassageWidget,
            ),
          );
        });
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({super.key, this.text, this.sender, this.isMe});

  final String? text;
  final String? sender;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(color: Colors.black45),
          ),
          Material(
            borderRadius: isMe == true
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
            elevation: 5.0,
            color: isMe == true ? Colors.lightBlueAccent : Colors.blue,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text('$text',
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
