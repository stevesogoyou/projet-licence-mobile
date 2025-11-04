import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voiture/commandes/addCommande.dart';
import 'package:voiture/commandes/allCommande.dart';
import 'package:voiture/fonctions/fonctions.dart';
import 'package:timeline_tile/timeline_tile.dart';


class AllNotif extends StatefulWidget {
  const AllNotif({super.key});

  @override
  State<AllNotif> createState() => _AllNotifState();
}

class _AllNotifState extends State<AllNotif> {
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
        title: Text("Mes notifications"),
        backgroundColor: Colors.blueGrey,

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
            return Center(child: Text('Aucune notification disponible'));
          } else {
            return AnimatedBuilder(
              animation: commandeController,
              builder: (context, _) {
                String recherche = commandeController.text.trim().toLowerCase();
                List commandes = snapshot.data!;
                commandes = commandes.where((e) {
                  return e['statutCommande'] == 'Rejetee' || e['statutCommande'] == 'Finalisée';
                } ).toList();
                return ListView.builder(
                  itemCount: commandes.length,
                  padding: EdgeInsets.all(15),
                  itemBuilder: (BuildContext context, int index) {
                    Map commande = commandes[index];
                    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(commande['dateCommande']));
                    return
                      TimelineTile(
                        isFirst: index==0,
                        isLast: index +1 == commandes.length,
                        alignment: TimelineAlign.start,//8
                        beforeLineStyle: const LineStyle(color: Colors.black38, thickness: 2),
                        indicatorStyle: IndicatorStyle(
                          color: commande['statutCommande'] == 'Rejetee' ? Colors.red : Colors.green,
                          width: 22,
                          padding: EdgeInsets.all(5),

                        ),

                        endChild: Card(
                          elevation: 2,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "La commande N° ${commande['id']} a été ${commande['statutCommande']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 25),
                                if (commande['statutCommande'] == 'Rejetee' && commande['motif'] != null)
                                  Text(
                                    "Motif du refus : ${commande['motif']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.brown,
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
