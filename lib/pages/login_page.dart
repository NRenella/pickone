import 'package:flutter/material.dart';
import 'package:pickone/components/my_text_field.dart';
import 'package:pickone/components/my_button.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 50,),
                // welcome back message
                Text(
                  "Welcome Back I Missed You!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25,),
                // email text field
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false),
                const SizedBox(height: 10,),
                // password text field
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true),
                const SizedBox(height: 25,),
                MyButton(onTap: (){}, text: "Sign In")

                // sign in button
                // not a member? register now
              ],
            ),
          ),
        ),
      ),
    );
  }
}