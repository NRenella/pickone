import 'package:flutter/material.dart';
import 'package:pickone/components/my_text_field.dart';
import 'package:pickone/components/my_button.dart';

class LoginPage extends StatefulWidget{
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn(){}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                // sign in button
                MyButton(onTap: signIn, text: "Sign In"),
                // not a member? register now
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}