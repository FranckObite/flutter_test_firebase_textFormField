import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/* import 'package:firebase_core/firebase_core.dart'; */
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';
import 'loading_page.dart';

/* import 'loading_page.dart'; */

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  late TextEditingController controllerUserName;
  late TextEditingController controllerEmail;
  late TextEditingController passWord;
  late TextEditingController confimPassword;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerUserName = TextEditingController();
    controllerEmail = TextEditingController();
    confimPassword = TextEditingController();
    passWord = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controllerEmail.dispose();
    controllerUserName.dispose();
    passWord.dispose();
    confimPassword.dispose();
  }

  void enregistrer() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: controllerEmail.text, password: passWord.text);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoadingPage()));

      setState(() {
        controllerUserName.text = '';
        controllerEmail.text = '';
        confimPassword.text = "";
        passWord.text = '';
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Méssage d'erreur"),
              content: Text(e.code),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(), */
      backgroundColor: const Color.fromARGB(255, 3, 37, 65),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 100.0, bottom: 10, left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 5,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/logo.png'), fit: BoxFit.cover)),
            ),
            const Spacer(),
            monTexfield(
                context: context,
                controller: controllerEmail,
                label: "Email",
                obscureText: false,
                labelColor: Colors.white54),
            monTexfield(
                context: context,
                controller: passWord,
                label: "Mot de passe",
                obscureText: true,
                labelColor: Colors.white54),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => dialog(),
                    child: const Text(
                      "Mot de Passe oublié? ",
                      style: TextStyle(color: Colors.lightBlue),
                    ))
              ],
            ),
            const SizedBox(
              height: 80,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () => enregistrer(),
                child: const Text(
                  "Connexion",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                )),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Vous n'avez pas de compte? ",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const HomePage())));
                    },
                    child: const Text(
                      "Créez en un! ",
                      style: TextStyle(color: Colors.lightBlue),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> dialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Reinitialisation de mot de pass"),
            content: monTexfield(
                context: context,
                controller: controllerEmail,
                label: "Email",
                obscureText: false,
                labelColor: Colors.black),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Annuler")),
                  TextButton(
                      onPressed: () => modifierMot2Pass(),
                      child: const Text(
                        "Valider",
                        style: TextStyle(color: Colors.green),
                      )),
                ],
              )
            ],
          );
        });
  }

  modifierMot2Pass() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controllerEmail.text);
      setState(() {
        controllerEmail.text = " ";
        Navigator.of(context).pop();
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verifier votre boite mail")));
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() {
        Navigator.of(context).pop();
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  SizedBox monTexfield(
      {required BuildContext context,
      required TextEditingController controller,
      required String label,
      required bool obscureText,
      required Color labelColor}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 14,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
              fillColor: Colors.white,
              label: Text(
                label,
                style: TextStyle(color: labelColor),
              )),
          controller: controller,
        ),
      ),
    );
  }
}
