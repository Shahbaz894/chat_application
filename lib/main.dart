

import 'package:chat_application/shared/constant.dart';
import 'package:chat_application/view/auth_screen/login_page.dart';

import 'package:chat_application/view/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'helper/helper_function.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(apiKey: Constant.apiKey,
            appId: Constant.appId,
            messagingSenderId: Constant.messagingSenderId,
            projectId: Constant.projectId)
    );

  }else{
    await Firebase.initializeApp(
        options: FirebaseOptions(apiKey: Constant.apiKey,
            appId: Constant.appId,
            messagingSenderId: Constant.messagingSenderId,
            projectId: Constant.projectId)
    );

  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool _isSignedIn=false;
  initState(){
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus()async{
    await HelperFunctions.getUserLoggedInStatus().then((value){
      if(value!=null){
        _isSignedIn=value;

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

      home: _isSignedIn ? const HomePage() :const LoginPage( ),
    );
  }
}


