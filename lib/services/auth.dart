import 'package:chat_app/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(User user){
    return user!=null?UserModel(uId: user.uid): null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return _userFromFirebaseUser(user);
    }
    catch(ex){
    print(ex.toString());
    }
  }
Future signUpWithEmailAndPassword(String email, String password) async {
  try{

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user;
    return _userFromFirebaseUser(user);
  }
  catch(ex){
    print(ex.toString());
  }
}

Future resetPassword(String email) async {
    try{
   return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(ex){
      print(ex.toString());
    }
}

  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(ex){
      print(ex.toString());
    }
  }

}