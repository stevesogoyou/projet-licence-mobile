import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/commandes/allCommande.dart';
import 'package:voiture/formulaireCommande/commandeStandard.dart';
import 'dart:convert';
import 'package:voiture/Cart/cartAll.dart';
import 'package:voiture/bottomNav.dart';
import 'package:voiture/garage/allgarage.dart';
import 'package:voiture/homepage/dashboard.dart';
import 'package:voiture/notification/allNotif.dart';
import 'package:voiture/piece/allpiece.dart';
import 'package:voiture/profil/profil.dart';
import 'package:voiture/models/garage.dart';
import 'package:voiture/fonctions/fonctions.dart';
import 'package:voiture/formulaireCommande/commandePremium.dart';


void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ),
);



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Index actuel pour la barre de navigation
  bool isSearch = false;
  TextEditingController _controllerSearch = TextEditingController();
  PageController _controllerAccueil = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: functionAppBar(

      ),
      body: PageView(

        controller: _controllerAccueil,
        onPageChanged: (index){

          setState(() {_currentIndex = index;});
        },
        children: [
          Dashboard(
            controller: _controllerSearch,
          ),

          // Deuxième écran (Garages)
          AllCommande(), // Utilisez simplement AllGarage() sans arguments

          // Troisième écran (Pièces)
          AllPiece(),

          // Troisième écran (Pièces)
          //CartScreen(), // Assurez-vous d'importer AllPiece si nécessaire

          // Quatrième écran (Profil)
          MyProfileScreen(), // Assurez-vous d'importer Profil si nécessaire
        ],
      ),


      // Barre de navigation inférieure
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Mettez à jour l'index actuel ici en fonction de l'index sélectionné

            _currentIndex = index;
            _controllerAccueil.animateToPage(_currentIndex, duration: Duration(milliseconds: 200), curve: Curves.linear);
            setState(() {});

        },
      ),
    );
  }

  functionAppBar() {
    if(isSearch){
      return AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
          leading: IconButton(onPressed: (){
            setState(() {
              isSearch = false;
              _controllerSearch.text = "";
            });

          },
              icon: Icon(Icons.arrow_back, color: Colors.white,)),
        title: TextField(
          decoration: InputDecoration(
            hintText: "Rechercher un garage",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
            controller : _controllerSearch
        ),
        actions: [
          IconButton(onPressed: (){
            _controllerSearch.text = "";
          }, icon: Icon(Icons.close, color: Colors.white,)),
        ],

      );
    }
    return AppBar(
      automaticallyImplyLeading: false, //si je fais un push sur la page, il n'y pas d'icone de retour par exemple
      centerTitle: true,
      backgroundColor: Colors.blueGrey,
      elevation: 0,
      // leading: Icon(Icons.menu),
      title: Text("Gear of Togo", style: TextStyle(color: Colors.white),),
      actions: [
        Stack(//est là pour empiler les choses
          children: [
            IconButton(onPressed: (){
              navigateToBoard(context, AllNotif(), true);
            }, icon: Icon(Icons.notifications, color: Colors.white,)),
            Positioned(
                bottom: 15,
                left: 8,
                child: Icon(Icons.brightness_1, color: Colors.red, size: 12,))
          ],
        ),
      ],
      leading: IconButton(onPressed: (){
        setState(() {
          isSearch = true;
        });

      }, icon: Icon(Icons.search, color: Colors.white,)),

    );

  }
}
