class Garage {
  final String nomGarage;
  final String adresseGarage;
  final String ville;
  final String numeroGarage;

  Garage({
    required this.nomGarage,
    required this.adresseGarage,
    required this.ville,
    required this.numeroGarage,
  });

  // Ajoutez une méthode de désérialisation (fromJson)
  factory Garage.fromJson(Map<String, dynamic> json) {
    return Garage(
      nomGarage: json['nomGarage'].toString(),
      adresseGarage: json['adresseGarage'].toString(),
      ville: json['ville'].toString(),
      numeroGarage: json['numeroGarage'].toString(),
    );
  }
}
