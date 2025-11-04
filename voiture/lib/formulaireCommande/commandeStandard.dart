import 'dart:ffi';

import 'package:flutter/material.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';
import 'components/square_tile.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class CommandeStandard extends StatefulWidget {
  CommandeStandard({super.key});

  @override
  _CommandeStandardState createState() => _CommandeStandardState();
}
class _CommandeStandardState extends State<CommandeStandard> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final chassisNumberController = TextEditingController();
  final plaqueController = TextEditingController();
  //final nbCylindreController = TextEditingController();
  final boiteVitesseController = TextEditingController();
  final assuranceController = TextEditingController();
  final totalController = TextEditingController();
  bool isFilled = false;
  bool isMarqueFilled = false;
  bool isChassisFilled = false;
  bool isPieceFilled = false;
  final List<String> categories = [
    'Mini-citadines',
    'Petites voitures',
    'Voitures compactes',
    'Grosses voitures',
    'Voitures de prestige',
    'Voitures de luxe',
    'SUV',
    'Grandes voitures familiales',
    'Voitures de sport',
    'Je ne sais pas'
  ];
  String? selectedCategory;

  final List<String> carBrands = [
    'Hyundai',
    'Nissan',
    'Mercedes-Benz',
    'Volkswagen',
    'BMW',
    'Audi',
    'Lexus',
    'Toyota',
    'Ford',
    'Opel',
  ];
  String? selectedCarBrand;

  final List<String> boite = [
    'Automatique',
    'Manuelle',
  ];
  String? selectedBoite;

  final List<String> assurance = [
    'Oui',
    'Non',
  ];
  String? selectedAssurance;


  // sign user in method
  void userOrder() {
    if (selectedCategory != null && selectedCarBrand != null && isFilled ) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Attention",
        //desc: "Une surfacturation sera appliquée en raison de la rapidité de la livraison",
        desc: "Une fois la commande payée, elle ne peut être annulée",
        btnCancelText: "Annuler", // Modifier le texte du bouton Cancel
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      ).show();
    } else {
      // Affichez un pop-up demandant à l'utilisateur de remplir tous les champs obligatoires.
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: "Champs obligatoires",
        desc: "Veuillez remplir tous les champs avant de commander.",
        btnOkOnPress: () {},
      ).show();
    }


  }
  bool _checkIfAllFieldsFilled() {
    if (isMarqueFilled && isChassisFilled && isPieceFilled ) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double textFieldWidth = MediaQuery.of(context).size.width - 48.0; // Largeur du TextField en fonction de l'écran
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,title: Text("Passez une commande",style: TextStyle(color: Colors.black),),
      iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView( // Ajout du SingleChildScrollView
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.feed_rounded,
                  size: 100,
                ),

                const SizedBox(height: 20),

                // welcome back, you've been missed!
                Text(
                  'Veuillez commander s\'il vous plaît !',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 50),

                Text(
                  'Catégorie de la voiture', // Texte que vous souhaitez ajouter
                  style: TextStyle(
                    color: Colors.grey[700], // Couleur du texte
                    fontSize: 16, // Taille du texte
                    fontWeight: FontWeight.bold, // Texte en gras

                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: textFieldWidth, // Largeur du conteneur égale à la largeur de l'écran
                  height: 56.0, // Hauteur du conteneur, réglée à la hauteur du TextField Password
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                        // Marquez le champ comme rempli lorsque l'utilisateur sélectionne une pièce.
                        isPieceFilled = true;
                        // Vérifiez si tous les champs obligatoires sont remplis pour activer ou griser le bouton "Commander !".
                        _checkIfAllFieldsFilled();
                        print("Selected Category: $selectedCategory");
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      isExpanded: true,

                    ),
                  ),
                ),


                const SizedBox(height: 20),

                Text(
                  'Marque de la voiture', // Texte que vous souhaitez ajouter
                  style: TextStyle(
                    color: Colors.grey[700], // Couleur du texte
                    fontSize: 16, // Taille du texte
                    fontWeight: FontWeight.bold, // Texte en gras
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: textFieldWidth, // Largeur du conteneur égale à la largeur de l'écran
                  height: 56.0, // Hauteur du conteneur, réglée à la hauteur du TextField Password
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCarBrand,
                      onChanged: (value) {
                        setState(() {
                          selectedCarBrand = value!;
                        });
                        // Marquez le champ comme rempli lorsque l'utilisateur sélectionne une pièce.
                        isPieceFilled = true;
                        // Vérifiez si tous les champs obligatoires sont remplis pour activer ou griser le bouton "Commander !".
                        _checkIfAllFieldsFilled();
                      },
                      items: carBrands.map((brand) {
                        return DropdownMenuItem<String>(
                          value: brand,
                          child: Text(brand),
                        );
                      }).toList(),
                      isExpanded: true,

                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Type de boîte à vitesse', // Texte que vous souhaitez ajouter
                  style: TextStyle(
                    color: Colors.grey[700], // Couleur du texte
                    fontSize: 16, // Taille du texte
                    fontWeight: FontWeight.bold, // Texte en gras
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: textFieldWidth, // Largeur du conteneur égale à la largeur de l'écran
                  height: 56.0, // Hauteur du conteneur, réglée à la hauteur du TextField Password
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedBoite,
                      onChanged: (value) {
                        setState(() {
                          selectedBoite = value!;
                        });
                        // Marquez le champ comme rempli lorsque l'utilisateur sélectionne une pièce.
                        isPieceFilled = true;
                        // Vérifiez si tous les champs obligatoires sont remplis pour activer ou griser le bouton "Commander !".
                        _checkIfAllFieldsFilled();
                      },
                      items: boite.map((boite) {
                        return DropdownMenuItem<String>(
                          value: boite,
                          child: Text(boite),
                        );
                      }).toList(),
                      isExpanded: true,

                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Avez vous une assurance ?', // Texte que vous souhaitez ajouter
                  style: TextStyle(
                    color: Colors.grey[700], // Couleur du texte
                    fontSize: 16, // Taille du texte
                    fontWeight: FontWeight.bold, // Texte en gras
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: textFieldWidth, // Largeur du conteneur égale à la largeur de l'écran
                  height: 56.0, // Hauteur du conteneur, réglée à la hauteur du TextField Password
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedAssurance,
                      onChanged: (value) {
                        setState(() {
                          selectedAssurance = value!;
                        });
                        // Marquez le champ comme rempli lorsque l'utilisateur sélectionne une pièce.
                        isPieceFilled = true;
                        // Vérifiez si tous les champs obligatoires sont remplis pour activer ou griser le bouton "Commander !".
                        _checkIfAllFieldsFilled();
                      },
                      items: assurance.map((assurance) {
                        return DropdownMenuItem<String>(
                          value: assurance,
                          child: Text(assurance),
                        );
                      }).toList(),
                      isExpanded: true,

                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'N° châssis (voir carte grise)', // Texte que vous souhaitez ajouter
                  style: TextStyle(
                    color: Colors.grey[700], // Couleur du texte
                    fontSize: 16, // Taille du texte
                    fontWeight: FontWeight.bold, // Texte en gras
                  ),
                ),
                const SizedBox(height: 10,),
                MyTextField(
                  controller: chassisNumberController, // Utilisation du contrôleur pour le numéro de châssis
                  hintText: 'Numéro de châssis du véhicule', // Texte d'invite pour le numéro de châssis
                  obscureText: false, // Le numéro de châssis ne doit pas être masqué
                  //borderRadius: BorderRadius.circular(10.0),
                  // Utilisez la fonction de rappel pour mettre à jour isFilled
                  onIsFilledChanged: (newValue) {
                    setState(() {
                      isFilled = newValue;
                    });
                  },



                ),

                const SizedBox(height: 20),

                Text(
                  'N° de votre plaque (ex: AZ-1214)', // Texte que vous souhaitez ajouter
                  style: TextStyle(
                    color: Colors.grey[700], // Couleur du texte
                    fontSize: 16, // Taille du texte
                    fontWeight: FontWeight.bold, // Texte en gras
                  ),
                ),
                const SizedBox(height: 10,),
                MyTextField(
                  controller: plaqueController, // Utilisation du contrôleur pour le numéro de châssis
                  hintText: 'N° de votre plaque', // Texte d'invite pour le numéro de châssis
                  obscureText: false, // Le numéro de châssis ne doit pas être masqué
                  //borderRadius: BorderRadius.circular(10.0),
                  // Utilisez la fonction de rappel pour mettre à jour isFilled
                  onIsFilledChanged: (newValue) {
                    setState(() {
                      isFilled = newValue;
                    });
                  },



                ),

                const SizedBox(height: 20),

                // Text(
                //   'Total de la commande', // Texte que vous souhaitez ajouter
                //   style: TextStyle(
                //     color: Colors.grey[700], // Couleur du texte
                //     fontSize: 16, // Taille du texte
                //     fontWeight: FontWeight.bold, // Texte en gras
                //   ),
                // ),
                // const SizedBox(height: 10,),
                // MyTextField(
                //   controller: totalController, // Utilisation du contrôleur pour le numéro de châssis
                //   hintText: 'Numéro de châssis du véhicule', // Texte d'invite pour le numéro de châssis
                //   obscureText: false, // Le numéro de châssis ne doit pas être masqué
                //   //borderRadius: BorderRadius.circular(10.0),
                // ),

                // const SizedBox(height: 20),
                // Text(
                //   'Ajoutez tous les articles de votre\n commande dans votre panier. Merci', // Texte que vous souhaitez ajouter
                //   style: TextStyle(
                //     color: Colors.red[700], // Couleur du texte
                //     fontSize: 16, // Taille du texte
                //     fontWeight: FontWeight.bold, // Texte en gras
                //
                //   ),
                // ),
                //
                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: userOrder,

                ),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
