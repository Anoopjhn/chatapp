import 'package:chat_app/constants/app_font_style.dart';
import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helper-function.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/ui/pages/converstion_page.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}
String _myName;

class _SearchPageState extends State<SearchPage> {
  TextEditingController serachController = TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  Widget searchList(){
    return searchSnapshot !=null?ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot.docs.length,
        itemBuilder: (context, index){
          return searchTile(
            userName: searchSnapshot.docs[index].data()["name"],
            userEmail: searchSnapshot.docs[index].data()["email"],

          );
        }):Container();
  }

  initiateSearch(){
    databaseMethods.getUserByUsername(serachController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
    }

  createChatRoomAndStartConversation({String userName}){
    if(userName != null || userName==Constants.myName){
      //TODO implement logic here
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId" : chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationPage(chatRoomId)));
    }
    else{
      JobkaroAlerts.showToast("You cannot sent message to yourself");
    }
  }

  Widget searchTile({String userName, String userEmail}){
    return Container(
      child: ListTile(
        title: Text(userName, style: AppFontStyle.labelTextStyle3(APP_BLACK_COLOR),),
        subtitle: Text(userEmail, style: AppFontStyle.labelTextStyle3(APP_BLACK_COLOR),),
        trailing: RaisedButton(onPressed: (){
          createChatRoomAndStartConversation(userName: userName);
        },
          padding: EdgeInsets.all(10),
          color: PRIMARY_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Message', style: AppFontStyle.labelTextStyle2(APP_WHITE_COLOR), ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: Text(
    'Search', style: AppFontStyle.appBarTittle(APP_WHITE_COLOR),),
    backgroundColor: PRIMARY_COLOR,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecorationWidget(hintText: 'Search username....'),
                        controller: serachController,
                      ),
                    ),
                    SizedBox(width: 8,),
                    GestureDetector(
                      onTap: (){
                        initiateSearch();
                      },
                      child: CircleAvatar(
                        backgroundColor: PRIMARY_COLOR,
                        radius: 24,
                        child: Icon(Icons.search, color: APP_WHITE_COLOR,),
                      ),
                    )
                  ],
                ),
              ),
            ),
            searchList()

          ],
        ),
      ),
    );
  }
}



getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

