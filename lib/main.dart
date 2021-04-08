
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/ui/pages/chat_room_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'helper/helper-function.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    bool value = await HelperFunctions.getUserLoggedInSharedPreference();
    userIsLoggedIn = value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anoop Messenger',
      theme: ThemeData(
          backgroundColor: Colors.white,
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: userIsLoggedIn? ChatRoomPage() : Authenticate()

    );
  }
}


