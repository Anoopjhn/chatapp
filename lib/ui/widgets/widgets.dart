import 'package:chat_app/constants/app_font_style.dart';
import 'package:chat_app/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



InputDecoration InputDecorationWidget({String labelText, String hintText, Widget prefix}){
  return InputDecoration(
    hintText: hintText,
    hintStyle: AppFontStyle.labelTextStyle(PRIMARY_COLOR),
    prefixIcon: prefix,
    labelText: labelText,
    labelStyle: AppFontStyle.labelTextStyle(PRIMARY_COLOR),
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: PRIMARY_COLOR)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: PRIMARY_COLOR)
      ),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: PRIMARY_COLOR),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide(color: PRIMARY_COLOR),
    ),

  );
}

class JobkaroAlerts{

  static showToast(String msg){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: PRIMARY_COLOR,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

}





