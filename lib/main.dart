import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:pickone/firebase_options.dart';
import 'package:pickone/services/auth/auth_service.dart';
import 'package:pickone/services/auth/auth_gate.dart';
import 'package:pickone/services/auth/card_provider.dart';


// Our main function we run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable landscape mode on the phone
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Create two providers one for AuthService and one for the CardProvider
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(create: (context) => AuthService()),
          ChangeNotifierProvider<CardProvider>(create: (context) => CardProvider()),
        ],
          child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );

  }
}
