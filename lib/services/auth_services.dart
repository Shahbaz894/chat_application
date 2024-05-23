import 'package:chat_application/helper/helper_function.dart';
import 'package:chat_application/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

//login with email and password
  Future loginWithUserNameandPassword(String email,String password)async{
    try{

      User user=(await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        return true;
      }


    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  // register the user
Future registerUserWithEmailandPassword(String fullName,String email,String password)async{


  try{
    User user =(await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
    if(user !=null){
      DatabaseServices(uid: user.uid).savingUserData(fullName,email);
      return true;
    }

  }on FirebaseAuthException catch(e){
    print(e);
  }
}
//sign out function
Future signOut()async{

try{

  await HelperFunctions.saveUserLoggedInStatus(false);
  await HelperFunctions.saveUserEmailSF('');
  await HelperFunctions.saveUserNameSF('');
  await firebaseAuth.signOut();

}catch(e){
  return null;
}
}

}