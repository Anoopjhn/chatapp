import 'package:chat_app/constants/app_font_style.dart';
import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {

  final String chatRoomId;
  ConversationPage(this.chatRoomId);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}



class _ConversationPageState extends State<ConversationPage> {
  TextEditingController messageController = TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatMessagesStream;
  QuerySnapshot snapshot;

  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessagesStream,
        builder: (context, snapshot){
         return snapshot.hasData?ListView.builder(
           itemCount: snapshot.data.docs.length,
             itemBuilder: (context, index){
             return MessageTile(snapshot.data.docs[index].data()["message"],
                 snapshot.data.docs[index].data()["sendBy"]== Constants.myName  );
             }
         ): Container();
        }
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message" : messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
   databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
     setState(() {
       chatMessagesStream = value;
     });
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
        title: Text(
        'Chat', style: AppFontStyle.appBarTittle(APP_WHITE_COLOR),),
    backgroundColor: PRIMARY_COLOR,
    ),
      body: Container(
        child: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height-150,
                child: ChatMessageList()
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: Colors.black,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(

                        decoration: InputDecorationWidget(
                          hintText: 'Message....',
                        ),
                        style: TextStyle(color: Colors.white),
                        controller: messageController,
                      ),
                    ),
                    SizedBox(width: 8,),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: CircleAvatar(
                        backgroundColor: PRIMARY_COLOR,
                        radius: 24,
                        child: Icon(Icons.send, color: APP_WHITE_COLOR,),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  bool isSendByme;

  MessageTile(this.message, this.isSendByme);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByme? 2:12 , right: isSendByme? 12:2),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByme? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSendByme?  PRIMARY_COLOR : Colors.black54,
          borderRadius: isSendByme? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ): BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )
        ),
        child: Text(message, style:  AppFontStyle.labelTextStyle(APP_WHITE_COLOR),),
      ),
    );
  }
}

