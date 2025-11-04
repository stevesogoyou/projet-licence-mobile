import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voiture/fonctions/fonctions.dart';
import 'package:voiture/models/cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> cartItems = [];
  Map<int, int> itemQuantities = {}; // Un mapping entre l'ID de l'article et sa quantité

  @override
  void initState() {
    super.initState();
    fetchCartItem().then((items) {
      setState(() {
        cartItems = items;
        // Initialisez la quantité de chaque article à 1
        for (Cart cartItem in cartItems) {
          itemQuantities[cartItem.id] = 1;
        }
      });
    }).catchError((error) {
      print("Erreur lors du chargement des articles du panier : $error");
    });
    super.initState();
    fetchCartItem().then((items) {
      setState(() {
        cartItems = items;
      });
    }).catchError((error) {
      print("Erreur lors du chargement des articles du panier : $error");

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
            'Mon panier',
            textAlign: TextAlign.center,
        ),

        actions: [
          IconButton(

            icon: Icon(Icons.delete_sweep, color: Colors.red),
            onPressed: () {
              //print("imagePath ${fetchCartItem.imageItem}");
              // Action à effectuer lorsque le bouton "Vider" est pressé
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(

          children: [
            ListView.separated(
              shrinkWrap: true,
              itemCount: cartItems.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.white,
                  thickness: 1.0,

                );
              },
              itemBuilder: (BuildContext context, int index) {
                Cart cartItem = cartItems[index];
                return FutureBuilder<String>(
                  future: fetchItemImage(cartItem.id), // Appelez la fonction pour récupérer le nom de l'image
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Affichez un indicateur de chargement pendant la récupération de l'image.
                    } else if (snapshot.hasError) {
                      return Text('Erreur lors du chargement de l\'image');

                    } else {
                      String imageName = snapshot.data!;
                      return Card(
                        elevation: 10.0,// Utilisation du Card widget pour chaque article
                        shape: const RoundedRectangleBorder(

                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),

                        child : ListTile(
                          title: Row(
                            children: [
                              // Petite Row à gauche avec l'image de l'article
                              Container(
                                padding: EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width - 320, // Définissez la largeur maximale ici
                                child: Image.asset(
                                  'assets/images/$imageName.jpg', // Utilisez le nom de l'image récupéré
                                  width: 150, // Ajustez la taille de l'image comme vous le souhaitez
                                  height: 100,

                                ),
                              ),
                              // Grande Row au centre avec le nomItem et le prix
                              Expanded(
                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.nomItem,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${cartItem.prix} F CFA',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Petite Row à droite avec le bouton + et la quantité
                              Container(
                                child: Column(

                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add_circle),
                                      onPressed: () {
                                        setState(() {
                                          itemQuantities[cartItem.id] = (itemQuantities[cartItem.id] ?? 1) + 1;
                                        });
                                      },
                                    ),
                                    Text(
                                      '${itemQuantities[cartItem.id] ?? 1}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                    IconButton(
                                      icon:
                                      itemQuantities[cartItem.id] == 1 ? Icon(
                                          Icons.delete,
                                          color: Colors.red)
                                          :
                                      Icon(Icons.remove_circle,),//88
                                      onPressed: () {
                                        setState(() {
                                          if (itemQuantities[cartItem.id] == 1) {
                                            // Si la quantité est de 1, supprimez l'article
                                            // Vous devrez implémenter cette logique
                                          } else {
                                            itemQuantities[cartItem.id] = (itemQuantities[cartItem.id] ?? 1) - 1;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),


    );
  }
}
