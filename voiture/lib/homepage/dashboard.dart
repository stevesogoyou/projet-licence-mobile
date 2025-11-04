import 'package:flutter/material.dart';
import 'package:voiture/fonctions/fonctions.dart';
import 'package:voiture/formulaireCommande/commandePremium.dart';
import 'package:voiture/formulaireCommande/commandeStandard.dart';
import 'package:voiture/garage/allgarage.dart';
import 'package:voiture/models/garage.dart';

class Dashboard extends StatefulWidget {
  final TextEditingController controller;

  const Dashboard({super.key, required this.controller});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with AutomaticKeepAliveClientMixin{
  Future<List<Garage>>? future;

  @override
  void initState() {
    super.initState();
    future = fetchGarages();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 8, left: 14, right: 12, bottom: 16),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 250,
              margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage('assets/images/pexels-esmihel-muhammad-18108320.jpg'),//884l
                    fit: BoxFit.cover
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.2),
                  ],
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

            ),
            SizedBox(height: 15,),
            ListTile(
              title: Text(
                "Nos garages", // Texte à ajouter
                style: TextStyle(
                  fontSize: 18, // Taille de la police
                  fontWeight: FontWeight.bold, // Poids de la police
                ),
              ),
              trailing: OutlinedButton(
                onPressed: (){
                  navigateToBoard(context, AllGarage(), true);
                },
              child: Text("Voir tout"),),
            ),
            SizedBox(height: 10,),
            FutureBuilder<List<Garage>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print("Error fetching garages: ${snapshot.error}");
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No data available'));
                } else {
                  print("Number of garages: ${snapshot.data?.length}");
                  return AnimatedBuilder(
                    animation: widget.controller,
                    builder: (context,_) {
                      String recherche = widget.controller.text.trim().toLowerCase();
                      List<Garage> garages = snapshot.data!;
                      garages = garages.where((element) => element.nomGarage.toLowerCase().contains(recherche)).toList();
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: garages.length,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          String garageName = garages[index].nomGarage;

                          // Construire le chemin de l'image à partir du nom du garage
                          String imagePath = 'assets/images/outils2.jpg';

                          return InkWell(
                            onTap: (){
                              Garage garage = garages[index];
                              showModalBottomSheet(context: context,
                                  isScrollControlled: true,
                                  builder: (context){
                                return DraggableScrollableSheet(
                                  expand: false,
                                  maxChildSize: 0.8,
                                  initialChildSize: 0.2,
                                  minChildSize: 0.1,
                                  builder: (context, _) {
                                    return ListView(
                                      shrinkWrap: true,
                                      children: [
                                        SizedBox(height: 10,),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(garageName, style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            ),),
                                          ),
                                        ),
                                        SizedBox(height: 6,),
                                        Center(
                                            child: Text(garage.adresseGarage)),
                                        SizedBox(height: 6,),
                                        Center(
                                            child: Text(garage.numeroGarage)),//55
                                      ],
                                    );
                                  }
                                );
                              });
                            },
                            child: Card(
                              color: Colors.transparent, // Rendre la Card transparente
                              elevation: 0, // Réglez la hauteur de l'ombre de la Card à 0
                              child: Container(
                                margin: EdgeInsets.all(10), // Marge autour de chaque Card
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
                                      spreadRadius: 2, // Écart de l'ombre
                                      blurRadius: 5, // Flou de l'ombre
                                      offset: Offset(0, 3), // Position de l'ombre
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: AssetImage(imagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 40,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      garageName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
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
                  );
                }
              },
            ),
          ],
        ),
      );
  }

  @override
  bool get wantKeepAlive => true;
}
