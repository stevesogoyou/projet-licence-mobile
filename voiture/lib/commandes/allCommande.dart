import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voiture/commandes/addCommande.dart';
import 'package:voiture/fonctions/fonctions.dart';

class AllCommande extends StatefulWidget {
  const AllCommande({Key? key});

  @override
  State<AllCommande> createState() => _AllCommandeState();
}

class _AllCommandeState extends State<AllCommande> {
  final TextEditingController commandeController = TextEditingController();
  late Future<List> future;

  @override
  void initState() {
    super.initState();
    future = fetchCommande();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Toutes les commandes'),
        actions: [
          IconButton(
            onPressed: () {
              navigateToBoard(context, AddCommande(), true);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error fetching commandes: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty || snapshot.data == null) {
            return Center(child: Text('Aucune commande disponible'));
          } else {
            return AnimatedBuilder(
              animation: commandeController,
              builder: (context, _) {
                String recherche = commandeController.text.trim().toLowerCase();
                List commandes = snapshot.data!;

                return ListView.builder(
                  itemCount: commandes.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map commande = commandes[index];
                    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(commande['dateCommande']));

                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Commande N° ${commande['id']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  commande['statutCommande'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: getStatusColor(commande['statutCommande']),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text("Les pièces commandées :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            for (int i = 0; i < commande['details'].length; i++)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.brightness_1, size: 16, color: Colors.blue),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(commande['details'][i]['piece_nom'] ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text("Quantité : ${commande['details'][i]['quantitePiece']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: 10),
                            if(commande['statutCommande'] == 'Rejetee' && commande['motif'] != null )
                              Text(
                                "Motif du refus : ${commande['motif']}",
                                style: TextStyle(
                                fontSize: 14,
                                  color: Colors.brown
                                ),
                              ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                  Text(
                                    " $formattedDate",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

Color getStatusColor(String statutCommande) {
  switch (statutCommande.toLowerCase()) {
    case 'en attente':
      return Colors.orange;
    case 'finalisée':
      return Colors.green;
    case 'rejetee':
      return Colors.red;
    default:
      return Colors.black; // Couleur par défaut si le statut n'est pas reconnu
  }
}
