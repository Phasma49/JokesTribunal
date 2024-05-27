import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme.dart';
import 'firebase_options.dart';
import 'src/home_page_screen.dart';
import 'src/authentication/auth_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      theme: const MaterialTheme(TextTheme())
          .light(), // Utilisation du thème clair
      home: home(),
    );
  }

  Widget home() {
    if (FirebaseAuth.instance.currentUser != null) {
      return const HomePageScreen();
    } else {
      return const LogInScreen();
    }
  }
}
