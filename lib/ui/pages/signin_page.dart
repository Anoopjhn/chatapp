import 'package:chat_app/constants/app_font_style.dart';
import 'package:chat_app/constants/colors.dart';
import 'package:chat_app/constants/strings.dart';
import 'package:chat_app/helper/helper-function.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_room_page.dart';

class SignInPage extends StatefulWidget {

  final Function toogle;
  SignInPage(this.toogle);


  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();

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
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/image.png', height: 180,),
                SizedBox(height: 16,),
                Text('Welcome Back', style: AppFontStyle.regularSmallTextStyle(PRIMARY_COLOR, textSize: 30.0),),
                SizedBox(height: 16,),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                          null: 'Please enter valid email id';
                        },
                        focusNode: f1,
                        controller: emailController,
                        decoration: InputDecorationWidget(labelText: 'Email'),
                      ),
                      SizedBox(height: 8,),
                      TextFormField(

                        validator: (val){
                          return val.length>6? null: 'please enter minimum 7 characters ';
                        },
                        focusNode: f2,
                        controller: passwordController,
                        decoration: InputDecorationWidget(labelText: 'Password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("This action will be work soon...", style: AppFontStyle.regularTextStyle3(APP_BLACK_COLOR, textSize: 20.0), textAlign: TextAlign.center,),
                                      SizedBox(height: 6,),
                                      Text("That promise will be kept", style: AppFontStyle.regularTextStyle3(APP_BLACK_COLOR, textSize: 20.0), textAlign: TextAlign.center,),
                                      SizedBox(height: 6,),
                                      CircleAvatar(
                                        backgroundImage: ExactAssetImage('assets/images/anoop.jpeg'),
                                        radius: 48,
                                      )
                                    ],
                                  )
                              );
                            }
                        );
                      },
                      child: Text('Forgot password', style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 12
                      ),),
                    )
                  ],
                ),
                SizedBox(height: 8,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(onPressed: (){
                    if(formKey.currentState.validate()){
                      f2.unfocus();
                      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
                      setState(() {
                        isLoading = true;
                      });

                      databaseMethods.getUserByUserEmail(emailController.text).then((val){
                        snapshotUserInfo = val;
                        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0].data()['name']);
                      });

                      authMethods.signInWithEmailAndPassword(emailController.text, passwordController.text).then((val){
                        if(val!=null){
                          HelperFunctions.saveUserLoggedInSharedPreference(true);
                          HelperFunctions.getUserLoggedInSharedPreference();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRoomPage()));
                        }
                      });

                    }
                  },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    color: PRIMARY_COLOR,
                  child: Text('Sign in', style: AppFontStyle.headingTextStyle(APP_WHITE_COLOR),),),
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
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                Text("This action will be work soon...", style: AppFontStyle.regularTextStyle3(APP_BLACK_COLOR, textSize: 20.0), textAlign: TextAlign.center,),
                                  SizedBox(height: 6,),
                                  Text("That promise will be kept", style: AppFontStyle.regularTextStyle3(APP_BLACK_COLOR, textSize: 20.0), textAlign: TextAlign.center,),
                                  SizedBox(height: 6,),
                                  CircleAvatar(
                                      backgroundImage: ExactAssetImage('assets/images/anoop.jpeg'),
                                      radius: 48,
                                  )
                                    ],
                                  )
                            );
                          }
                      );
                    },
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
                    Text("Don't have an account yet? ", style: AppFontStyle.headingTextStyle(APP_BLACK_COLOR,textSize: 14.0),),
                    InkWell(child: Text("Sign up", style: TextStyle(fontSize: 14.0, decoration: TextDecoration.underline),),
                    onTap: (){widget.toogle();},
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
