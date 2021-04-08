
import 'package:chat_app/constants/app_font_style.dart';
import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/helper/helper-function.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/ui/pages/chat_room_page.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final Function toogle;
  SignUpPage(this.toogle);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: isLoading?Container(
          child: Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),)),
        ):Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/image.png', height: 180,),
                  SizedBox(height: 32,),
                  TextFormField(
                    validator: (val){
                      return val.isEmpty?'Please enter username':null;
                    },
                    controller: userNameController,
                    decoration: InputDecorationWidget(labelText: 'Username'),
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    validator: (val){
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                      null: 'Please enter valid email id';
                    },
                    controller: emailController,
                    decoration: InputDecorationWidget(labelText: 'Email'),
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    validator: (val){
                      return val.length>6? null: 'please enter minimum 7 characters ';
                    },
                    controller: passwordController,
                    decoration: InputDecorationWidget(labelText: 'Password'),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(onPressed: (){
                      if(formKey.currentState.validate()){
                        Map<String, String> userInfoMap= {
                          "name" : userNameController.text,
                          "email" : emailController.text
                        };
                        HelperFunctions.saveUserNameSharedPreference(userNameController.text);
                        HelperFunctions.saveUserEmailSharedPreference(emailController.text);
                        setState(() {
                          isLoading = true;
                        });
                        authMethods.signUpWithEmailAndPassword(emailController.text, passwordController.text).then((val){

                        //print('${val.uId}');

                          databaseMethods.uploadUserInfo(userInfoMap);
                          HelperFunctions.saveUserLoggedInSharedPreference(true);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRoomPage()));
                        });
                      }
                    },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      color: PRIMARY_COLOR,
                      child: Text('Sign Up', style: AppFontStyle.headingTextStyle(APP_WHITE_COLOR),),),
                  ),
                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: PRIMARY_COLOR
                        ,),
                      SizedBox(width: 8,),
                      Text("OR LOGIN WITH GOOGLE", style: AppFontStyle.headingTextStyle(PRIMARY_COLOR, textSize: 12.0),),
                      SizedBox(width: 8,),
                      Container(
                        height: 1.0,
                        width: 40.0,
                        color: PRIMARY_COLOR
                        ,)
                    ],
                  ),
                  SizedBox(height: 12,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      elevation: 1,
                      onPressed: (){},
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      color: APP_WHITE_COLOR,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/images/image2.png', height: 12,),
                          Text('Log in with google', style: AppFontStyle.headingTextStyle(APP_BLACK_COLOR, textSize: 14.0),),
                          Text('')
                        ],
                      ),),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Do you have an account? ", style: AppFontStyle.headingTextStyle(APP_BLACK_COLOR,textSize: 14.0),),
                      InkWell(
                          onTap: (){widget.toogle();},
                          child: Text("Sign In", style: TextStyle(fontSize: 14.0, decoration: TextDecoration.underline),))
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
