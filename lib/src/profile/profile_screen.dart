import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../classes/passwords.dart';
import '../../classes/network_checker.dart';
import '../../classes/snack_bars.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User currentUser = FirebaseAuth.instance.currentUser!;

  final String changeNameLabel = "Modifier mon nom";
  final String changeEmailAddressLabel = "Modifier mon adresse email";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text("Nom : ${currentUser.displayName}"),
            trailing: IconButton(
              tooltip: changeNameLabel,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final GlobalKey<FormState> formKey =
                            GlobalKey<FormState>();

                        final TextEditingController lastDisplayName =
                            TextEditingController();

                        final TextEditingController newFirstName =
                            TextEditingController();
                        final TextEditingController newLastName =
                            TextEditingController();

                        String getDisplayName() {
                          String firstName = newFirstName.text
                                  .trim()
                                  .substring(0, 1)
                                  .toUpperCase() +
                              newFirstName.text
                                  .trim()
                                  .substring(1)
                                  .toLowerCase();
                          String lastName =
                              newLastName.text.trim().toUpperCase();
                          return "$firstName $lastName";
                        }

                        lastDisplayName.text = currentUser.displayName!;
                        return AlertDialog(
                          icon: const Icon(Icons.person),
                          title: Text(changeNameLabel),
                          content: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(children: [
                                TextFormField(
                                  enabled: false,
                                  controller: lastDisplayName,
                                  decoration: const InputDecoration(
                                      labelText: "Ancien nom",
                                      border: OutlineInputBorder()),
                                ),
                                MyFirstAndLastNamesFormField(
                                    firstName: newFirstName,
                                    lastName: newLastName,
                                    textInputAction: TextInputAction.done)
                              ]),
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler")),
                            TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await checkNetworkAvailability(context);
                                    currentUser
                                        .updateDisplayName(getDisplayName());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Le nom a été mis à jour. Relancez l'application pour être sûr de voir les modifications")));
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(changeNameLabel))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.edit)),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text("Email : ${currentUser.email}"),
            trailing: IconButton(
              tooltip: changeEmailAddressLabel,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final GlobalKey<FormState> formKey =
                            GlobalKey<FormState>();

                        final TextEditingController lastEmailAddress =
                            TextEditingController();
                        final TextEditingController newEmailAddress =
                            TextEditingController();

                        lastEmailAddress.text =
                            FirebaseAuth.instance.currentUser!.email!;
                        return AlertDialog(
                          icon: const Icon(Icons.mail),
                          title: Text(changeEmailAddressLabel),
                          content: SingleChildScrollView(
                            child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      enabled: false,
                                      controller: lastEmailAddress,
                                      validator: (value) {
                                        return value ==
                                                newEmailAddress.text.trim()
                                            ? "Votre nouvelle adresse mail ne peut pas être identique avec votre ancienne adresse mail"
                                            : null;
                                      },
                                      decoration: const InputDecoration(
                                          labelText: "Ancienne adresse mail",
                                          border: OutlineInputBorder()),
                                    ),
                                    MyEmailFormField(
                                        controller: newEmailAddress,
                                        textInputAction: TextInputAction.done)
                                  ],
                                )),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler")),
                            TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    try {
                                      await checkNetworkAvailability(context);
                                      currentUser.updateEmail(
                                          newEmailAddress.text.trim());
                                      Navigator.pop(context);
                                    } on FirebaseAuthException catch (e) {
                                      switch (e.code) {
                                        case "invalid-email":
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(myWarningSnackBar(
                                                  message:
                                                      "Adresse mail invalide"));
                                          break;
                                        case "email-already-in-use":
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(myWarningSnackBar(
                                                  message:
                                                      "Adresse mail déjà utilisée"));
                                          break;
                                        case "requires-recent-login":
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(myWarningSnackBar(
                                                  message:
                                                      "Veuillez vous reconnecter et réessayer"));
                                          break;
                                      }
                                    }
                                  }
                                },
                                child: Text(changeEmailAddressLabel))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.edit)),
          ),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          icon: const Icon(Icons.lock_reset),
                          title: const Text("Réinitialisation de mot de passe"),
                          content: const Text(
                              "Êtes vous sur de vouloir réinitialiser votre mot de passe ?\n\n"
                              "Vous allez recevoir un email pour réinitialiser votre mot de passe."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler")),
                            TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.sendPasswordResetEmail(
                                      email: currentUser.email!);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                    "Réinitialiser mon mot de passe"))
                          ],
                        ));
              },
              child: const Text("Réinitialiser mon mot de passe")),
        ],
      ),
    );
  }
}
