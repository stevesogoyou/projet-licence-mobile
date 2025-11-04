import 'package:flutter/material.dart';
import 'package:voiture/models/garage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:voiture/fonctions/fonctions.dart';

class AllGarage extends StatefulWidget {
  const AllGarage({Key? key}) : super(key: key);

  @override
  State<AllGarage> createState() => _AllGarageState();
}

class _AllGarageState extends State<AllGarage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Liste des garages"),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.grey.shade300,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
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
                  "Liste de nos garages",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 35),
              ],
            ),
          ),SizedBox(height: 30),
          Expanded(
            child: FutureBuilder<List<Garage>>(
              future: fetchGarages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else {
                  final garages = snapshot.data;
                  return ListView.builder(
                    itemCount: garages!.length,
                    itemBuilder: (context, index) {
                      final isEven = index.isEven;
                      return GestureDetector(
                        onTap: () {
                          // Action à effectuer lorsque la carte est cliquée
                        },
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: isEven ? Colors.white : Colors.black87,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(15),
                            title: Text(
                              garages[index].nomGarage,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isEven ? Colors.black : Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              garages[index].adresseGarage,
                              style: TextStyle(
                                color: isEven ? Colors.black54 : Colors.white70,
                              ),
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
