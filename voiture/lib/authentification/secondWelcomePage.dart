import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:voiture/fonctions/fonctions.dart';
import 'package:voiture/homepage/home.dart';

class secondPage extends StatefulWidget {
  @override
  _secondPageState createState() => _secondPageState();
}

class _secondPageState extends State<secondPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  String _authorizedMessage = '';
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    bool isAvailable = await _localAuth.canCheckBiometrics;
    setState(() {
      _authorizedMessage = isAvailable ? 'Utilisez votre empreinte digitale ou mot de passe pour déverrouiller' : 'Aucune authentification biométrique disponible';
    });
  }

  Future<void> _authenticate() async {
    try {

      bool isAuthenticated = await _localAuth.authenticate(


        localizedReason: 'Veuillez vous authentifier pour déverrouiller',
      );
     if(mounted) navigateToBoard(context, HomePage()); // le if est une propriete dans les classes pour signaler que le context de la page est disponible

    } catch (e) {

      print('Erreur d\'authentification : $e');
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/car5.png", // Utilisez le chemin de votre icône personnalisée
              width: 100, // Définissez la largeur de l'image selon vos besoins
              height: 100, // Définissez la hauteur de l'image selon vos besoins
              //color: Colors.black, // Définissez la couleur de l'icône selon vos besoins
            ),

            SizedBox(height: 20),
            SizedBox(height: 20),
            if (!_isAuthenticated) ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey,
                onPrimary: Colors.yellow,
              ),
              child: Text('CONNEXION'),
            ),
          ],
        ),
      ),
    );
  }
}
