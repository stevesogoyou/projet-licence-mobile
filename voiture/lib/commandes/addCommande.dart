import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_paygateglobal/paygate/paygate.dart';
import 'package:hive/hive.dart';
import 'package:voiture/fonctions/fonctions.dart';
import 'package:voiture/homepage/home.dart';
import 'package:voiture/models/item.dart';
import 'package:http/http.dart' as http;

class AddCommande extends StatefulWidget {
  const AddCommande({Key? key}) : super(key: key);

  @override
  _AddCommandeState createState() => _AddCommandeState();
}

class _AddCommandeState extends State<AddCommande> {
  int? voiture;
  List voitures = [];
  List<Map<String, dynamic>> pieces = [];
  late Future<List<Item>> future;
  List allPieces = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    future = fetchItem();
    _loadData();
    Paygate.init(apiKey: '56729e9a-97a2-4514-81ac-a19b8cfc256f');
  }

  _loadData() async {
    try {
      voitures = await fetchVoitureOfUser();
      setState(() {
        voitures = voitures.map((e) {
          return {
            'name': "${e['marque']} | ${e['numPlaque']}",
            'value': e['id'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading voitures: $e');
    }
    future = fetchItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Nouvelle commande"),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder<List<Item>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            allPieces = snapshot.data!
                .map((e) => {'prix': e.prix, 'nomItem': e.nomItem, 'id': e.id})
                .toList();
          }
          return SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                _buildVoitureDropdown(),
                SizedBox(height: 20),
                _buildPiecesListTile(),
                SizedBox(height: 20),
                _buildPieces(),
                SizedBox(height: 20),
                _buildCommanderButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoitureDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel("Choisir votre voiture", mandatory: true),
        buildSelect(
          context,
          selectedMenus: voitures,
          fieldLibelle: "name",
          fieldValue: "value",
          value: voiture,
          onChanged: (v) {
            setState(() {
              voiture = v;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPiecesListTile() {
    return ListTile(
      title: Text("Choisir vos pièces"),
      trailing: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          setState(() {
            pieces.add({'quantity': TextEditingController()});
          });
        },
      ),
    );
  }

  Widget _buildCommanderButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          _onCommanderTap();
        },
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Commander !',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildPieces() {
    List<Widget> children = [];
    for (int i = 0; i < pieces.length; i++) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPieceDropdown(i),
                  SizedBox(height: 8),
                  _buildQuantityField(i),
                  SizedBox(height: 8),
                  _buildRemovePieceButton(i),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      children: children,
    );
  }

  Widget _buildPieceDropdown(int index) {
    return buildSelect(
      context,
      selectedMenus: allPieces,
      style: TextStyle(color: Colors.black),
      onChanged: (p) {
        setState(() {
          pieces[index]['piece'] = p;
        });
      },
      fieldLibelle: 'nomItem',
      fieldValue: 'id',
      value: pieces[index]['piece'],
    );
  }

  Widget _buildQuantityField(int index) {
    return buildField(
      'Quantité',
      controller: pieces[index]['quantity'],
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildRemovePieceButton(int index) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(Icons.close, color: Colors.red),
        onPressed: () {
          setState(() {
            pieces.removeAt(index);
          });
        },
      ),
    );
  }

  void _onCommanderTap() async {
    if (voiture != null && pieces.isNotEmpty) {
      var user = Hive.box('settings').get('user');
      Map<String, dynamic> map = {
        'voiture': voiture,
        'pieces': <Map<String, dynamic>>[],
        'user': user['id']
      };
      double total = 0;
      for (Map<String, dynamic> item in pieces) {
        if (item['piece'] == null || item['quantity'].text.trim().isEmpty) {
          showToast(context, "Veuillez renseigner une pièce et sa quantité");
          return;
        }
        int tt = int.parse(item['quantity'].text.trim());
        var p = allPieces.firstWhere((el) => el['id'] == item['piece']);
        total += ((p['prix'] ?? 0) * tt);
        map['pieces'].add({'quantity': tt, 'piece': item['piece']});
      }
      TextEditingController phoneCtrl = TextEditingController();
      String? network;
      String? res = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (cxt) {
          return DraggableScrollableSheet(
            expand: false,
            maxChildSize: .85,
            initialChildSize: .7,
            builder: (cxt, scrollCtrl) {
              return StatefulBuilder(
                builder: (context, updateFn) {
                  return ListView(
                    children: [
                      Container(
                        color: Colors.blueGrey,
                        child: ListTile(
                          title: Text('Paiement de la commande',
                              style: TextStyle(color: Colors.white)),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            buildLabel("Choisir le réseau"),
                            buildSelect(context,
                                value: network,
                                selectedMenus: ['MOOV', 'TMONEY'],
                                onChanged: (val) {
                                  updateFn(() {
                                    network = val;
                                  });
                                }),
                            buildLabel("Votre numéro de téléphone",
                                mandatory: true),
                            buildField(
                              null,
                              hint: "Votre numéro de téléphone",
                              suffixIcon: Icon(Icons.phone),
                              controller: phoneCtrl,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 8),
                            Center(
                                child: Text('Montant à payer : $total FCFA')),
                            SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context, "");
                              },
                              child: Text('Valider'),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      );
      if (res == null || phoneCtrl.text.trim().isEmpty) return;
      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/postOrder/'),
        body: json.encode(map),
        headers: {},
        encoding: Encoding.getByName('utf-8'),
      );
      if (response.statusCode == 201) {
        // La requête a réussi, donc extraire l'ID de la commande de la réponse.
        final responseData = json.decode(response.body);
        final orderId = responseData['order_id']; //  la clé utilisée ici doit correspondre à celle renvoyée par mon API

        print('ID de la commande créée : $orderId');

        Paygate.pay(
          version: PaygateVersion.v2,
          callbackUrl: '$apiBaseUrl/api/payment/$orderId/',
          amount: total,
          phoneNumber: phoneCtrl.text.trim(),
          provider: network == 'MOOV' ? PaygateProvider.moovMoney : PaygateProvider.tmoney,
        ).then((value) {
          navigateToBoard(context, HomePage());
        });
      } else {
        showToast(context, "La création de la commande a échoué");
        // Affichez éventuellement plus d'informations sur l'échec en utilisant response.body
      }

    } else {
      showToast(context, "Veuillez renseillez les champs");
      showToast(context, "Veuillez renseillez les champs");
    }
  }
}
