import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../home_page_screen.dart';

class VerifMailScreen extends StatefulWidget {
  const VerifMailScreen({super.key});

  @override
  State<VerifMailScreen> createState() => _VerifMailScreenState();
}

class _VerifMailScreenState extends State<VerifMailScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //User came back from his Emails
      _checkMailVerification();
    }
    if (kDebugMode) {
      switch (state) {
        case AppLifecycleState.resumed:
          print("app in resumed");
          break;
        case AppLifecycleState.inactive:
          print("app in inactive");
          break;
        case AppLifecycleState.paused:
          print("app in paused");
          break;
        case AppLifecycleState.detached:
          print("app in detached");
          break;
        case AppLifecycleState.hidden:
          print("app in hidden");
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _checkMailVerification() {
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePageScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vérification de l'email"),
        actions: [
          IconButton(
            tooltip: "Rafraîchir",
              onPressed: _checkMailVerification,
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Inscription réussie !",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Maintenant que vous êtes inscrit sur l'application, il vous faut vérifier votre adresse mail.\n"
                "Pour ce faire, rien de plus simple, vous allez recevoir un mail vous demandant de valider votre adresse mail."
                "(Mail envoyé à l'adresse '${FirebaseAuth.instance.currentUser!.email}')"),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Si vous avez validé votre adresse mail et que vous n'êtes pas redirigé, cliquez sur le bouton de rafraîchissement en haut à droite de l'écran.\n"
                "Si vous n'avez pas reçu le mail (vérifiez bien vos courriers indésirables), vous pouvez cliquer sur le bouton ci dessous pour le renvoyer."),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () =>
                    FirebaseAuth.instance.currentUser!.sendEmailVerification(),
                child: const Text("Renvoyer le mail de vérification")),
          )
        ],
      ),
    );
  }
}
