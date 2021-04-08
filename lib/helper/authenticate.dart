import 'package:chat_app/ui/pages/signin_page.dart';
import 'package:chat_app/ui/pages/signup_page.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toogleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignInPage(toogleView);
    }
    else{
      return SignUpPage(toogleView);
    }
  }
}
