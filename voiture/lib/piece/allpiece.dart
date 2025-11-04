import 'package:flutter/material.dart';
import 'package:voiture/models/item.dart';
import 'package:voiture/fonctions/fonctions.dart';

class AllPiece extends StatefulWidget {
  const AllPiece({Key? key}) : super(key: key);

  @override
  State<AllPiece> createState() => _AllPieceState();
}

class _AllPieceState extends State<AllPiece> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'Liste des pièces disponible',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 35),
              ],
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: FutureBuilder<List<Item>>(
              future: fetchItem(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if(!snapshot.hasData || snapshot.data!.isEmpty || snapshot.data == null){
                  return Center(child: Text('Aucune pièces disponible'));
                }
                else {
                  final items = snapshot.data;
                  return ListView.builder(
                    itemCount: items!.length,
                    itemBuilder: (context, index) {
                      final isEven = index.isEven;
                      return GestureDetector(
                        onTap: () {
                          // Action à effectuer lorsque la carte est cliquée
                        },
                        child: Card(
                          elevation: 5,
                          margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: isEven ? Colors.white : Colors.black87,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            title: Row(
                              children: [
                                // Image à gauche
                                Image.asset(
                                  'assets/images/${items[index].imageName}.jpg',
                                  width: 80,
                                  height: 80,
                                ),
                                SizedBox(width: 20), // Ajustez cet espace selon vos besoins

                                // Informations dans la colonne de droite
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items[index].nomItem,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isEven
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        items[index].descriptionItem,
                                        style: TextStyle(
                                          color: isEven
                                              ? Colors.black54
                                              : Colors.white70,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        ' ${items[index].prix} XOF',
                                        style: TextStyle(
                                          color: isEven
                                              ? Colors.blue
                                              : Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
