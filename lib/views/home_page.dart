import 'package:firebase_test_app/views/connection_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/* import 'package:firebase_core/firebase_core.dart'; */
import 'package:firebase_auth/firebase_auth.dart';

import 'loading_page.dart';

/* import 'loading_page.dart'; */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  Future<void> enregistrer() async {
    final formState = _formKey.currentState;

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    if ((formState?.validate() ?? false) &&
        passWord.text == confimPassword.text &&
        passWord.text.length <= 6) {
      formState?.save();
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: controllerEmail.text, password: passWord.text);

        Navigator.of(context).pop();

        setState(() {
          controllerUserName.text = '';
          controllerEmail.text = '';
          confimPassword.text = "";
          passWord.text = '';

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoadingPage()));
        });
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
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Méssage d'erreur"),
              content: Text('Password should be at least 6 characters'),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(), */
      backgroundColor: const Color.fromARGB(255, 3, 37, 65),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 100.0, bottom: 10.0, left: 8.0, right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/logo.png'),
                        fit: BoxFit.cover)),
              ),
              const Spacer(),
              monTexfield(
                context: context,
                controller: controllerUserName,
                label: 'User Name',
                obscureText: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ obligatoire';
                  }

                  return null;
                },
              ),
              monTexfield(
                context: context,
                controller: controllerEmail,
                label: 'Email',
                obscureText: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ obligatoire';
                  }
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              monTexfield(
                context: context,
                controller: passWord,
                label: "Mot de passe",
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ obligatoire';
                  }

                  return null;
                },
              ),
              monTexfield(
                context: context,
                controller: confimPassword,
                label: "Confirmer mot de passe",
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Champ obligatoire';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 80,
              ),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () => enregistrer(),
                  child: const Text(
                    "Inscription",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  )),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Vous avez déja un compte? ",
                      style: TextStyle(color: Colors.white)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const ConnectionPage())));
                      },
                      child: const Text(
                        "Connectez vous! ",
                        style: TextStyle(color: Colors.lightBlue),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox monTexfield(
      {required BuildContext context,
      required TextEditingController controller,
      required String label,
      required String? Function(String?)? validator,
      required bool obscureText}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 14,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: TextFormField(
          obscureText: obscureText,
          validator: validator,
          onSaved: (value) {
            controller.text = value!;
          },
          decoration: InputDecoration(
              fillColor: Colors.white,
              label: Text(
                label,
                style: const TextStyle(color: Colors.white54),
              )),
          controller: controller,
        ),
      ),
    );
  }
}
