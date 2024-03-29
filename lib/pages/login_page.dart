import 'package:flutter/material.dart';
import 'package:pickone/components/my_text_field.dart';
import 'package:pickone/components/my_button.dart';
import 'package:provider/provider.dart';
import 'package:pickone/services/auth/auth_service.dart';


class LoginPage extends StatefulWidget{
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    // Get the auth service
    final authService = Provider.of<AuthService>(context,listen:false);

    try {
      await authService.signInWithEmailandPassword(emailController.text, passwordController.text);
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),)));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/background.png',),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('lib/assets/logo_mascot.png')
                  ),
                  //welcome back message
                  Stack(
                    children: const <Widget>[
                      Text(
                        "PickOne",
                        style: TextStyle(
                          fontSize: 64,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
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
                      const Text(
                          'Not a member?',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.white,
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
      ),
    );
  }
}