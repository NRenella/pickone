import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pickone/components/my_text_field.dart';
import 'package:pickone/components/my_button.dart';
import 'package:provider/provider.dart';
import 'package:pickone/services/auth/auth_service.dart';
import 'package:pickone/components/profile_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/services/asset_bundle.dart';


class RegisterPage extends StatefulWidget{
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Uint8List ?imageController;

  void signUp() async {
    if (passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Passwords do not match!"),
          ),
      );
      return;
    }
    if (usernameController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a username"),
        ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try{
      await authService.signUpWithEmailandPassword(
          usernameController.text,
          emailController.text,
          passwordController.text,
          imageController
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      imageController = img;
    });
  }

  @override
  void initState(){
    super.initState();
    setDefault();
  }

  Future<void> setDefault() async {
    imageController = (await rootBundle.load('lib/assets/avatar-removebg.png')).buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        // background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/background.png',),
            fit: BoxFit.cover,
          ),
        ),
        // profile picture section
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      imageController != null ?
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: MemoryImage(imageController!),
                            backgroundColor: Colors.white.withOpacity(0),
                          )
                      :
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0),
                        radius: 80,
                        backgroundImage: const AssetImage('lib/assets/avatar-removebg2.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 90,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  // Create Account Message
                  const Text(
                    "Lets create an account for you",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 25,),
                  // username text field
                  MyTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false),
                  const SizedBox(height: 10,),
                  // email text field
                  MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false),
                  const SizedBox(height: 10,),
                  // Password text field
                  MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true),
                  const SizedBox(height: 10,),
                  // Confirm password text field
                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true),
                  const SizedBox(height: 25,),
                  // sign in button
                  MyButton(onTap: signUp, text: "Sign Up"),
                  // not a member? register now
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Already a member?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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