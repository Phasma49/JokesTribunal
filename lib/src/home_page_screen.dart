import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/database_management/crud_operations.dart';
import 'authentication/auth_screens.dart';
import 'profile/profile_screen.dart';
import 'game_management/user_invitations_screens.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final MenuController menuController = MenuController();
  int nbrOfNewInvitations = 0;

  void _fetchNbrOfNewInvitations() async {
    nbrOfNewInvitations = await readUserNewInvitations(
            userId: FirebaseAuth.instance.currentUser!.uid)
        .then((invitationList) => invitationList.length);
    setState(() {});
  }

  @override
  void initState() {
    _fetchNbrOfNewInvitations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        actions: [
          IconButton(
            tooltip: "Nouvelles invitations",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserNewInvitationListScreen()),
              );
              _fetchNbrOfNewInvitations();
            },
            icon: Badge(
              isLabelVisible: nbrOfNewInvitations > 0,
              label: Text(nbrOfNewInvitations.toString()),
              child: const Icon(Icons.mail),
            ),
          ),
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const ProfileScreen())),
                child: const Text("Profil"),
              ),
              MenuItemButton(
                child: const Text("Se déconnecter"),
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        icon: const Icon(Icons.logout),
                        title: const Text("Déconnexion"),
                        content: const Text(
                            "Êtes-vous sur de vouloir vous déconnecter ?\n\n"
                            "Vous devrez vous re connecter pour accèder de nouveau à l'application."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Annuler"),
                          ),
                          TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => const LogInScreen()));
                              },
                              child: const Text("Oui, me déconnecter"))
                        ],
                      );
                    }),
              ),
            ],
            builder: (_, MenuController controller,
                Widget? child) {
              return IconButton(
                tooltip: "Menu",
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.menu),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                "Bienvenue ${FirebaseAuth.instance.currentUser!.displayName}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text: FirebaseAuth.instance.currentUser!.uid));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Copié dans le presse papier !")),
                  );
                },
                child: const Text("Copier votre identifiant utilisateur")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: const TextSpan(
                style:
                    TextStyle(color: Colors.black, fontSize: 18, height: 1.5),
                text: "Bienvenue dans ",
                children: [
                  TextSpan(
                      text: "JokesTribunal",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: " ! Sur cette application, vous pouvez "),
                  TextSpan(
                      text: "juger les blagues de vos amis",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ". Pour ce faire vous pouvez "),
                  TextSpan(
                      text: "créer une partie avec eux",
                      style: TextStyle(decoration: TextDecoration.underline)),
                  TextSpan(
                    text: " et ",
                  ),
                  TextSpan(
                      text:
                          "enregistrer leurs meilleures (ou les pires) blagues dans la partie",
                      style: TextStyle(decoration: TextDecoration.underline)),
                  TextSpan(text: " en y attribuant un score.\n\nAttention ! "),
                  TextSpan(
                      text:
                          "Une bonne blague peut faire gagner des points mais une mauvaise peut aussi en faire perdre !",
                      style: TextStyle(decoration: TextDecoration.underline)),
                  TextSpan(
                      text:
                          " Chaque joueur de la partie a le pouvoir de juger les autres et c'est vous qui choisissez le nombre de points gagnés ou perdus !")
                ],
              )),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserAcceptedInvitationsScreen()),
            );
          },
          child: const Text("Accèder à la liste des parties")),
    );
  }
}
