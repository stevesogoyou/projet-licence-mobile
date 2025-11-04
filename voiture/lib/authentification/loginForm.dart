import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:voiture/fonctions/fonctions.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/homepage/dashboard.dart';
import 'package:voiture/homepage/home.dart';
import '../../main.dart';

class LoginForm extends StatefulWidget {
  final AuthType type;
  const LoginForm({super.key, required this.type});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController nameCtrl = TextEditingController(),
      prenomCtrl = TextEditingController(),
      usernameCtrl = TextEditingController(),
      emailCtrl = TextEditingController(),
      passCtrl = TextEditingController(),
  telephoneCtrl = TextEditingController();
  String? sexe;
  bool loading = false;
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Text(
                widget.type == AuthType.login ? "Connexion" : "Inscription",
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white)),
            elevation: 0),
        body: Column(children: [
        Expanded(
        child: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
        const Text(
            "Renseignez vos identifiants pour vous connecter",
            style: TextStyle(
                color: Colors.white, //Color(0XFF273749),
                fontSize: 15,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.1)),
        const SizedBox(height: 35),
        Container(
        decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(8)),
    child: Column(
    crossAxisAlignment:
    CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      if(widget.type==AuthType.signUp)
    buildField(null,
    hint: "Saisissez votre nom",
    controller: nameCtrl,
    enabled: !loading,
    floatingLabelBehavior:
    FloatingLabelBehavior.auto,
    autovalidateMode: AutovalidateMode
        .onUserInteraction,
    prefixIcon: const Icon(Icons.perm_identity),
    fillColor: Colors.white,
    borderSide: .1,
    borderColor: Colors.white,
    filled: true),
    const Divider(height: 1),
      if(widget.type==AuthType.signUp)
    buildField(null,
    hint: "Saisissez votre prénom",
    controller: prenomCtrl,
    enabled: !loading,
    floatingLabelBehavior:
    FloatingLabelBehavior.auto,
    autovalidateMode: AutovalidateMode
        .onUserInteraction,
    prefixIcon: const Icon(Icons.person),

        fillColor: Colors.white,
        borderSide: .1,
        borderColor: Colors.white,
        filled: true),

      const SizedBox(height: 5),
      if(widget.type==AuthType.signUp)
        buildSelect(
          context,
          hint: "Choisir le sexe",
          selectedMenus: ['Homme', 'Femme', 'Non-binaire'],
          value: sexe,
          onChanged: (e) {
            setState(() {
              sexe = e;
            }
            );
          },
          bgColor: Colors.white,
          style: TextStyle(color: Colors.black),
        ),
      const Divider(height: 1),
      if(widget.type==AuthType.signUp)
      buildField(null,
          hint: "Saisissez votre numéro",
          controller: telephoneCtrl,
          keyboardType: TextInputType.number,
          enabled: !loading,
          floatingLabelBehavior:
          FloatingLabelBehavior.auto,
          autovalidateMode: AutovalidateMode
              .onUserInteraction,
          prefixIcon: const Icon(Icons.phone),

          fillColor: Colors.white,
          borderSide: .1,
          borderColor: Colors.white,
          filled: true),
      if(widget.type==AuthType.signUp)
      buildField(null,
          hint: "Saisissez votre email",
          controller: emailCtrl,
          enabled: !loading,
          floatingLabelBehavior:
          FloatingLabelBehavior.auto,
          autovalidateMode: AutovalidateMode
              .onUserInteraction,
          prefixIcon: const Icon(Icons.mail),

          fillColor: Colors.white,
          borderSide: .1,
          borderColor: Colors.white,
          filled: true),
      const Divider(height: 1),

      buildField(null,
          hint: "Saisissez votre pseudonyme",
          controller: usernameCtrl,
          enabled: !loading,
          floatingLabelBehavior:
          FloatingLabelBehavior.auto,
          autovalidateMode: AutovalidateMode
              .onUserInteraction,
          prefixIcon: const Icon(Icons.person_2),

          fillColor: Colors.white,
          borderSide: .1,
          borderColor: Colors.white,
          filled: true),
      const Divider(height: 1),
      buildField(null,
          hint: "Saisissez votre mot de passe",
          controller: passCtrl,
          enabled: !loading,
          floatingLabelBehavior:
          FloatingLabelBehavior.auto,
          autovalidateMode: AutovalidateMode
              .onUserInteraction,
          prefixIcon: const Icon(Icons.lock),
          obscureText: !visible,
          suffixIcon: IconButton(onPressed: () {
            setState(() {
              visible = !visible;
            });
          },
              icon: Icon(visible
                  ? Icons.visibility_off
                  : Icons.visibility)),
          fillColor: Colors.white,
          borderSide: .1,
          borderColor: Colors.white,
          filled: true)
    ])),
        const SizedBox(height: 20),
        TextButton(
        style: ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all(Colors.white),
    foregroundColor: MaterialStateProperty.all(
        Colors.blueGrey),
    shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
    borderRadius:
    BorderRadius.circular(12)))),
    onPressed: loading
    ? null
        : () async {
    if ( (widget.type == AuthType.login || ( widget.type == AuthType.signUp && nameCtrl.text
        .trim()
        .isNotEmpty && prenomCtrl.text
        .trim()
        .isNotEmpty && sexe != null)) &&
    passCtrl.text.trim().isNotEmpty&& usernameCtrl.text.trim().isNotEmpty) {
    setState(() {
    loading = true;
    });
    try {
    if (widget.type == AuthType.login) {
    await login();
    } else if (widget.type ==
    AuthType.signUp) {
    await register();
    }
    } catch (_) {
    if (mounted) {
    setState(() {
    loading = false;
    });
    showToast(
    context,
    "Une erreur s'est produite"
        );
    }
    }
    } else {
    showToast(context,
    'Formulaire invalide !');
    }
    },
    child: Center(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Flexible(
    child: Text(widget.type ==
    AuthType.login
    ? 'Se connecter': "S'inscire")),
      const SizedBox(width: 14),
      loading
          ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              color:
              Colors.redAccent,
              strokeWidth: 2))
          : const Icon(
          Icons.arrow_forward,
          size: 20)
    ])))),
              const SizedBox(height: 25),

            ])))),
    Center(
    child: TextButton(
    onPressed: () {
    if (widget.type == AuthType.login) {
    navigateToBoard(context, LoginForm(type: AuthType.signUp));
    } else if (widget.type == AuthType.signUp) {
    navigateToBoard(context, LoginForm(type: AuthType.login));
    }
    },
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text.rich(
    TextSpan(children: [
    TextSpan(text: widget.type == AuthType.login
    ? "Pas de compte?"
        : 'Vous avez déjà un compte?',
    style: const TextStyle(color: Colors.white70)),
    const TextSpan(text: " "),
    TextSpan(
    text: widget.type == AuthType.login
    ? "S'inscrire"
        : "Se connecter")
    ]),
    style: const TextStyle(
    fontSize: 16,
    decoration: TextDecoration.underline,
    color: Colors.white)),
    ))),
    ]));
    }

  Future login() async {
    _login({

      'username' : usernameCtrl.text.trim(),
      'password': passCtrl.text.trim()
    });
  }

  Future register() async {
    _register({
      'last_name': nameCtrl.text.trim(),
      'first_name': prenomCtrl.text.trim(),
      'email' : emailCtrl.text.trim(),
      'username' : usernameCtrl.text.trim(),
      'telephone' : telephoneCtrl.text.trim(),
      'password': passCtrl.text.trim()
    });
  }



  Future _login(Map model) async {
    try {
      print("Login $model");
      final response = await http.post(Uri.parse('$apiBaseUrl/api/login/'), body: json.encode(model),
      headers: {
        //'content-type':'application/json'
      }
      );
      print("tttt ${response.body}");
      Map res = json.decode(response.body);
      if (res['error']!= null) throw res;
      print("RESPONSE BODY =============== ${res}");
      await Hive.box('settings').put('user', res['user']);
      setState(() {
        loading = false;
      });
      navigateToBoard(context, HomePage());
        return;


    } catch (e) {
      print("_login error $e");
      loading = false;
      if (mounted) {
        setState(() {});
        String msg = 'Identifiants incorrects';

        showToast(context, msg);
      }
      rethrow;
    }
  }

  Future _register(Map model) async {
    try {
      final response = await http.post(Uri.parse('$apiBaseUrl/api/postUser/'), body : json.encode(model));
      print("LE MODEL EST $model");
      Map res = json.decode(response.body);
      if (res['error']!= null) throw res;
      await Hive.box('settings').put('user', res['user'] ?? model);
      setState(() {
        loading = false;
      });
      if (mounted) {
        navigateToBoard(context, HomePage());
      }
    } catch (e) {
      print("_register error $e");
      loading = false;
      if (mounted) {
        setState(() {});
        String msg = 'Une erreur s\'est produite';
        showToast(context, msg);
      }
    }
  }

  void onStatus(bool s, {String? message}) {
    setState(() {
      loading = s;
    });
    if (s) {
      showLoading(context, message ?? '....');
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }
}

enum AuthType { login, signUp }