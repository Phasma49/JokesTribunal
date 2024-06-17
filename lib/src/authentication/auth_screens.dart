import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../authentication/verif_mail_screen.dart';
import '../home_page_screen.dart';
import '../../../classes/passwords.dart';
import '../../classes/snack_bars.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  Future<void> signUp(
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    firstName = firstName.substring(0, 1).toUpperCase() +
        firstName.substring(1).toLowerCase();
    lastName = lastName.toUpperCase();
    String displayName = "$firstName $lastName";

    try {
      FirebaseAuth instance = FirebaseAuth.instance;

      UserCredential userCredential =
          await instance.createUserWithEmailAndPassword(
              email: email.trim(),
              password: password.trim());
      instance.currentUser?.updateDisplayName(displayName);
      if (kDebugMode) {
        print(userCredential);
      }
      if (userCredential.user!.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePageScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VerifMailScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-emai":
          ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(message: "Adresse mail invalide"));
          break;
        case "email-already-in-use":
          ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(message: "Adresse mail déjà utilisée"));
          break;
        case "operation-not-allowed":
          ScaffoldMessenger.of(context).showSnackBar(myErrorSnackBar(message: "Operation non autorisée : contactez le développeur"));
          break;
        case "weak-password":
          ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(message: "Mot de passe trop faible"));
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Inscription"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyFirstAndLastNamesFormField(
                          firstName: _firstName,
                          lastName: _lastName,
                          textInputAction: TextInputAction.next),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyEmailFormField(
                          controller: _email,
                          textInputAction: TextInputAction.next),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyPasswordFormFieldWithAnalyzerBox(
                          controller: _password,
                          textInputAction: TextInputAction.next),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyConfirmPasswordFormField(
                          controller: _confirmPassword,
                          passwordController: _password,
                          textInputAction: TextInputAction.done),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signUp(
                                email: _email.text.trim(),
                                password: _password.text.trim(),
                                firstName: _firstName.text.trim(),
                                lastName: _lastName.text.trim());
                          }
                        },
                        child: const Text("S'inscrire"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LogInScreen()));
                          },
                          child:
                              const Text("J'ai déjà un compte (Se connecter)")),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> logIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      if (kDebugMode) {
        print(userCredential);
      }
      if (userCredential.user!.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePageScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VerifMailScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-emai":
          ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(message: "Adresse mail invalide"));
          break;
        case "user-disabled":
          ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(message: "Utilisateur désactivé"));
          break;
        case "user-not-found":
          ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(message: "Utilisateur introuvable"));
          break;
        case "wrong-password":
          ScaffoldMessenger.of(context).showSnackBar(myWarningSnackBar(message: "Mot de passe erroné"));
          break;
      }
    }catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
      ),
      body: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyEmailFormField(
                        controller: _email,
                        textInputAction: TextInputAction.next),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyPasswordFormField(
                      controller: _password,
                      textInputAction: TextInputAction.done,
                      validator: (value) => value!.trim().isEmpty
                          ? "Veuillez entrer un mot de passe"
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          logIn(
                              email: _email.text.trim(),
                              password: _password.text.trim());
                        }
                      },
                      child: const Text("Se connecter"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()));
                        },
                        child: const Text(
                            "Je n'ai pas encore de compte (S'inscrire)")),
                  ),
                ],
              ))),
    );
  }
}
