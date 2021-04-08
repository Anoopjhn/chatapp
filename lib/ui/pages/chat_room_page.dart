import 'package:chat_app/constants/app_font_style.dart';
import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper-function.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/ui/pages/converstion_page.dart';
import 'package:chat_app/ui/pages/search_page.dart';
import 'package:chat_app/ui/pages/signin_page.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;


  Widget ChatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
        builder: (context, snapshot){
        return snapshot.hasData? ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
            return ChatRoomTile(
              snapshot.data.docs[index].data()["chatroomId"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                snapshot.data.docs[index].data()["chatroomId"]
            );
            }
        ): Container();
        }
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          'Chat Room', style: AppFontStyle.appBarTittle(APP_WHITE_COLOR),),
        backgroundColor: PRIMARY_COLOR,
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app, color: APP_WHITE_COLOR),onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Are you sure you want to Logout?", style: AppFontStyle.labelTextStyle3(APP_BLACK_COLOR), textAlign: TextAlign.center,),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text("No", style: AppFontStyle.labelTextStyle2(PRIMARY_COLOR),)
                            ),
                            VerticalDivider(width: 25,thickness: 16,),
                            FlatButton(
                                onPressed: (){

                                 authMethods.signOut();
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Authenticate()));
                                },
                                child: Text("Yes", style: AppFontStyle.labelTextStyle2(PRIMARY_COLOR),)
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
            );
          },)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage()));
        },
      ),
      body: ChatRoomList(),
      );

  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationPage(chatRoomId)));
      },
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: PRIMARY_COLOR,
        child: Text("${userName.substring(0,1)}", style: AppFontStyle. regularHeadingTextStyle(APP_WHITE_COLOR, textSize: 24.0),),
      ),
      title: Text(userName, style: AppFontStyle.regularTextStyle3(APP_BLACK_COLOR, textSize: 20.0)),
    );
  }
}
