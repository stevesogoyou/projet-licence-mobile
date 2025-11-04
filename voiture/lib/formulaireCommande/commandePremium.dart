import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class CommandePremium extends StatefulWidget {
  const CommandePremium({Key? key}) : super(key: key);

  @override
  State<CommandePremium> createState() => _CommandePremiumState();
}

class _CommandePremiumState extends State<CommandePremium> {
  late Color myColor;
  late Size mediaSize;
  String selectedCategory = 'Je ne sais pas'; // Vous pouvez définir une valeur par défaut ici.
  String selectedBrand = 'Toyota'; // Initialisez avec une valeur de la liste.


  TextEditingController emailController = TextEditingController();
  TextEditingController marqueController = TextEditingController();
  TextEditingController chassisController = TextEditingController();
  TextEditingController pieceController = TextEditingController();
  TextEditingController catCarController = TextEditingController();


  bool isMarqueFilled = false;
  bool isChassisFilled = false;
  bool isPieceFilled = false;

  @override
  Widget build(BuildContext context) {
    myColor = Colors.yellowAccent;
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: myColor,
            image: DecorationImage(
              image: const AssetImage("assets/images/pexels-derice-jason-fahnkow-4392657.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(myColor, BlendMode.dstATop),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 80),
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    // ...

    // Liste des options pour la pièce à commander
    final List<String> pieceOptions = ['Pièce 1', 'Pièce 2', 'Pièce 3'];

    // Variable pour suivre la sélection de l'utilisateur
    String selectedPiece = pieceOptions[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Veuillez commander 😁",
          style: GoogleFonts.lora(
            fontSize: 20,
            color: Colors.yellowAccent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 60),
        _buildGreyText("---CATEGORIE DE LA VOITURE---", textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        ),
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                //labelText: 'Catégories de la voiture',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                errorText: state.hasError ? state.errorText : null,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  items: [
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
                  ].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Container(
                        color: Colors.black, // Fond noir
                        child: Text(
                          category,
                          style: TextStyle(color: Colors.white), // Couleur du texte en blanc
                        ),
                      ),
                    );

                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                      print("liste categorie : $selectedCategory");
                    });
                  },


                ),

              ),

            );
          },
        ),



        const SizedBox(height: 40),
        _buildGreyText("---MARQUE DE LA VOITURE---", textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        ),

        // FormField<String>(
        //   builder: (FormFieldState<String> state) {
        //     return InputDecorator(
        //       decoration: InputDecoration(
        //         // labelStyle: TextStyle(
        //         //   color: Colors.white,
        //         // ),
        //         errorText: state.hasError ? state.errorText : null,
        //         filled: true,
        //         fillColor: Colors.black, // Fond noir
        //       ),
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton<String>(
        //           value: selectedBrand,
        //           items: [
        //             'Mercedes-benz',
        //             'Toyota',
        //             'Lexus',
        //             'Opel',
        //             'Mitsubishi',
        //             'BMW',
        //             'Audi',
        //             'Mazda',
        //             'Kia',
        //             'Renault',
        //             'Nissan',
        //             'Hyundai',
        //             'Volkswagen'
        //           ].map((String brand) {
        //             return DropdownMenuItem<String>(
        //               value: brand,
        //               child: Container(
        //                 color: Colors.black, // Fond noir
        //                 child: ListTile(
        //                   title: Text(
        //                     brand,
        //                     style: TextStyle(color: Colors.white), // Couleur du texte en blanc
        //                   ),
        //                 ),
        //               ),
        //             );
        //           }).toList(),
        //           onChanged: (String? newValue) {
        //             setState(() {
        //               selectedBrand = newValue!;
        //               print("liste marque: $selectedBrand ");
        //             });
        //           },
        //         ),
        //       ),
        //     );
        //   },
        // ),


        const SizedBox(height: 40),
        _buildGreyText("Numéro du châssis", textColor: Colors.white),
        _buildInputField(chassisController, textColor: Colors.white),
        const SizedBox(height: 40),
        _buildGreyText("Pièce à commander", textColor: Colors.white),
        _buildInputField(pieceController, textColor: Colors.white),
        // Liste déroulante pour la pièce à commander
        DropdownButton<String>(
          value: selectedPiece,
          items: pieceOptions.map((String piece) {
            return DropdownMenuItem<String>(
              value: piece,
              child: Text(
                  piece,
                  style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedPiece = newValue!;
            });
            // Marquez le champ comme rempli lorsque l'utilisateur sélectionne une pièce.
            isPieceFilled = true;
            // Vérifiez si tous les champs obligatoires sont remplis pour activer ou griser le bouton "Commander !".
            _checkIfAllFieldsFilled();
          },
        ),
        const SizedBox(height: 40),
        _buildGreyText(
          "Si vous voulez commander plus d'une pièce, ajoutez les au panier avant puis cochez la case ci-dessous",
          textColor: Colors.redAccent,
        ),
        const SizedBox(height: 40),
        _buildGreyText(
          "Commentaires (laissez si vous voulez un message au garagiste)",
        ),
        _buildInputField(emailController, textColor: Colors.white),
        //const SizedBox(height: 40,),
        //_buildGreyText("Total de la commande"),
        // Espace grisé pour afficher le total
        Container(
          color: Colors.grey.shade300,
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Total : 150 €", // Vous pouvez mettre ici le montant total
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Vérifiez si tous les champs obligatoires sont remplis.
              if (_checkIfAllFieldsFilled()) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: "Attention",
                  desc: "Une surfacturation sera appliquée en raison de la rapidité de la livraison",
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
                  desc: "Veuillez remplir tous les champs obligatoires avant de commander.",
                  btnOkOnPress: () {},
                ).show();
              }
            },
            style: ElevatedButton.styleFrom(
              primary: isMarqueFilled && isChassisFilled && isPieceFilled
                  ? Colors.yellowAccent
                  : Colors.grey, // Couleur de fond jaune si tous les champs sont remplis, sinon gris.
              minimumSize: const Size(150, 50), // Taille minimale du bouton
            ),
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: Colors.yellowAccent,
              ),
              child: Center(
                child: Text(
                  "Commander !",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),

                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
  // Fonction pour vérifier si tous les champs obligatoires sont remplis.
  bool _checkIfAllFieldsFilled() {
    if (isMarqueFilled && isChassisFilled && isPieceFilled) {
      return true;
    } else {
      return false;
    }
  }


  Widget _buildGreyText(String text, {Color textColor = Colors.grey, TextStyle? textStyle}) {
    return Text(
      text,
      style: textStyle ?? TextStyle(
        color: textColor,
      ),
    );
  }



  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false, Color? textColor}) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: textColor,//88
      ),
      obscureText: isPassword,
    );
  }
}


// Widget _buildRememberForgot() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           Checkbox(
  //               value: rememberUser,
  //               onChanged: (value) {
  //                 setState(() {
  //                   rememberUser = value!;
  //                 });
  //               }),
  //           _buildGreyText("*me"),
  //         ],
  //       ),
  //       TextButton(
  //           onPressed: () {}, child: _buildGreyText("I forgot my password"))
  //     ],
  //   );
  // }

  // Widget _buildLoginButton() {
  //   return ElevatedButton(
  //     onPressed: () {
  //       debugPrint("Email : ${emailController.text}");
  //       debugPrint("Password : ${passwordController.text}");
  //     },
  //     style: ElevatedButton.styleFrom(
  //       shape: const StadiumBorder(),
  //       elevation: 20,
  //       shadowColor: myColor,
  //       minimumSize: const Size.fromHeight(60),
  //     ),
  //     child: const Text("LOGIN"),
  //   );
  // }

  // Widget _buildOtherLogin() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         _buildGreyText("Or Login with"),
  //         const SizedBox(height: 10),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Tab(icon: Image.asset("assets/images/facebook.png")),
  //             Tab(icon: Image.asset("assets/images/twitter.png")),
  //             Tab(icon: Image.asset("assets/images/github.png")),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

