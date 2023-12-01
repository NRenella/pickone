import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.message,
                size: 80,
              ),
              // welcome back message
              // email text field
              // password text field
              // sign in button
              // not a member? register now
            ],
          ),
        );
      );
    );
  }
}