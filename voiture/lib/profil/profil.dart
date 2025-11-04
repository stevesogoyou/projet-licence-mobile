import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:voiture/authentification/loginForm.dart';
import 'package:voiture/authentification/secondWelcomePage.dart';
import 'package:voiture/car/addCarForm.dart';
import 'package:voiture/fonctions/fonctions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyProfileScreen(),
    );
  }
}

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late Future<int?> vehicleCount;
Map user = {};
  @override
  void initState() {
    super.initState();
    user = Hive.box('settings').get('user');
    vehicleCount = getCountFromVehicle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/logo_got_2.png'),
            ),
            SizedBox(height: 16),
            Text(
              user['username']??'John Doe',//8b
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              user['email']??'user@gmail.com', // Utilisez votre variable email ici
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            FutureBuilder<int?>(
              future: vehicleCount,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur de chargement');
                } else {
                  int? count =  snapshot.data ??  0; // Utilise snapshot.data pour obtenir la valeur de getCountFromVehicle
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      buildStatColumn('Nombre de véhicule', count?.toString() ?? 'Chargement...'),
                    ],
                  );
                }
              },
            ),

            SizedBox(height: 24),
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(15),
                title: Text(
                  'Ajouter une voiture',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCarForm(),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),

            ),

            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(15),
                title: Text(
                  'Déconnexion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textColor: Colors.red,
                onTap: () {
                  Hive.box('settings').clear();
                  navigateToBoard(context, LoginForm(type: AuthType.login));

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildStatColumn(String label, String value) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

}
