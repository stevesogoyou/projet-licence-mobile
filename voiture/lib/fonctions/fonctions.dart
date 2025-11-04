
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/models/commande.dart';
import 'package:voiture/models/detailCommande.dart';
import 'dart:convert';
import 'package:voiture/models/garage.dart';
import 'package:voiture/models/item.dart';
import 'package:voiture/models/cart.dart';

final String apiBaseUrl = "http://192.168.0.110:8000";

Future<List<Garage>> fetchGarages() async {
  final response = await http.get(Uri.parse('$apiBaseUrl/api/garageAll/'));//8l4

  if (response.statusCode == 200) {
    final List<dynamic> garageList = json.decode(response.body)['garages'];
    final List<Garage> garages = garageList.map((data) => Garage.fromJson(data)).toList();
    return garages;
    } else {
    throw Exception('Erreur de chargement des garages');
  }
}

Future<List<dynamic>> fetchCommande() async {
  Map user = Hive.box('settings').get('user');
  final response = await http.get(Uri.parse('$apiBaseUrl/api/orderOfUser/?utilisateur=${user['id']}'));//8
  if (response.statusCode == 200) {
    print(response.body);
    return json.decode(response.body)['orders'];
  } else {
    throw Exception('Erreur de chargement des commandes');
  }
}

Future<List<dynamic>> fetchVoitureOfUser() async {
  Map user = Hive.box('settings').get('user');
  final response = await http.get(Uri.parse('$apiBaseUrl/api/vehicleOfUser/?utilisateur=${user['id']}')); // 85

  if (response.statusCode == 200) {
    return json.decode(response.body)['vehicles']; // Extract 'vehicles' key
  } else {
    throw Exception('Erreur de chargement des garages');
  }
}



Future<List<DetailCommande>> fetchDetailCommande() async {
  final response = await http.get(Uri.parse('$apiBaseUrl/api/detailOrderAll/'));//85

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    final List<DetailCommande> detailcommande = jsonResponse.map((data) {
      return DetailCommande(
        commande: data['commande'],
        piece: data['piece'],
        quantitePiece : data['quantitePiece'],
      );
    }).toList();
    return detailcommande;
  } else {
    throw Exception('Erreur de chargement des garages');
  }
}

Future<List<Item>> fetchItem() async {
  final response = await http.get(Uri.parse('$apiBaseUrl/api/itemAll/'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((item) {
      return Item(
        nomItem: item['nomItem'],
        descriptionItem: item['descriptionItem'],
        prix: double.parse(item['prix']),
        id: item['id'],
        imageName: item['imageItem'],
      );
    }).toList();
  } else {
    throw Exception('Erreur de chargement des items');
  }
}


Future<List<Cart>> fetchCartItem() async {
  final response = await http.get(Uri.parse('$apiBaseUrl/api/cartAll/'));//848
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    final List<Cart> carts = jsonResponse.map((data) {
      return Cart(
        id : data['id'],
        nomItem: data['nomItem'].toString(),
        descriptionItem: data['descriptionItem'].toString(),
        prix : data['prix'].toString(),
        itemCart : data['itemCart'],
        imageItem : data['imageItem'].toString(),
      );
    }).toList();
    return carts;
  } else {
    throw Exception('Erreur de chargement des pièces');
  }
}

Future<String> fetchItemImage(int itemId) async {
  final response = await http.get(Uri.parse('$apiBaseUrl/api/item/$itemId'));//,
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final String imageName = jsonResponse['imageItem'];
    print("Nom de l'image normalement ${imageName}");
    return imageName;

  } else {
    throw Exception('Erreur de chargement de l\'image');

  }
}

Future<int?> getCountFromVehicle() async {
  Map user = Hive.box('settings').get('user');
  final String backendUrl = apiBaseUrl; // Remplacez ceci par l'URL réel de votre backend
  final String countRoute = "/api/vehicleCount/?utilisateur=${user['id']}"; // Assurez-vous d'avoir la route correcte pour le comptage dans votre API

  try {
    final response = await http.get(Uri.parse('$backendUrl$countRoute'));

    if (response.statusCode == 200) {
      // La requête a réussi, analysez la réponse JSON
      final Map<String, dynamic> data = json.decode(response.body);
      final int count = data['count'];
      return count;
    } else {
      // La requête a échoué avec un code d'erreur
      print("Erreur lors de la requête au backend. Statut : ${response.statusCode}");
      return null; // Retourne null pour indiquer une erreur
    }
  } catch (e) {
    // Une erreur s'est produite lors de la requête
    print("Erreur lors de la requête au backend : $e");
    return null; // Retourne null pour indiquer une erreur
  }
}

Future<T?> navigateToBoard<T>(context, Widget page, [bool canBack = false]) {
  try {
    return Navigator.of(context).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (BuildContext context) {
          return page;
        }), (route) {
      return canBack;
    });
  } catch (_) {}
  return Future.value();
}

Widget buildLabel(String msg,
    {EdgeInsets? padding, bool mandatory = false, Color? textColor}) {
  List<TextSpan> children = [TextSpan(text: msg)];
  if (mandatory) {
    children.add(const TextSpan(
        text: ' *', style: TextStyle(color: Colors.redAccent, fontSize: 12)));
  }
  return Padding(
      padding: padding ?? const EdgeInsets.only(left: 3.0, top: 20, bottom: 4),
      child: SelectableText.rich(TextSpan(children: children),
          style: TextStyle(
              color: textColor, fontSize: 15, fontWeight: FontWeight.w600)));
}


Widget buildField(String? label,
    {TextEditingController? controller,
      void Function(String)? onChanged,
      void Function(String)? onSubmitted,
      AutovalidateMode? autovalidateMode,
      String? Function(String?)? validator,
      FloatingLabelBehavior? floatingLabelBehavior,
      bool? filled,
      Color? fillColor,
      double? radius,
      FocusNode? focusNode,
      int? maxLines = 1,
      int? minLines = 1,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      bool required = false,
      String? hint,
      Widget? icon,
      Widget? suffixIcon,
      Widget? prefixIcon,
      Widget? prefix,
      int? maxLength,
      String? counterText,
      bool? obscureText,
      String? help,
      Widget? suffix,
      bool? enabled,
      EdgeInsets? contentPadding,
      bool autofocus = false,
      bool noBorder = false,
      TextStyle? helperStyle,
      TextStyle? hintStyle,
      double? borderSide,
      Color? borderColor,
      String? errorText,
      TextAlign? textAlign,
      Function()? onEditingComplete,
      Function(String)? onFieldSubmitted}) {
  return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 5.0),
      child: TextFormField(
          autovalidateMode: autovalidateMode,
          validator: validator,
          enabled: enabled ?? true,
          maxLines: (minLines ?? 1) > 1 ? null : (maxLines),
          minLines: minLines ?? 1,
          maxLength: maxLength,
          autofocus: autofocus,
          controller: controller,
          focusNode: focusNode,
          textAlign: textAlign ?? TextAlign.start,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText ?? false,
          onChanged: onChanged,
          //onSubmitted: onSubmitted,
          decoration: InputDecoration(
              fillColor: fillColor,
              filled: filled,
              floatingLabelBehavior:
              floatingLabelBehavior ?? FloatingLabelBehavior.always,
              contentPadding: contentPadding,
              hintText: hint,
              hintMaxLines: 5,
              hintStyle: hintStyle ??
                  const TextStyle(fontSize: 14.5, color: Colors.black26),
              icon: icon,
              enabledBorder: noBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 4),
                  borderSide: BorderSide(
                      color: fillColor != null
                          ? borderColor ?? Colors.blueGrey
                          : Colors.black,
                      width: borderSide ?? 1)),
              disabledBorder: noBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 4),
                  borderSide: BorderSide(
                      color: fillColor != null
                          ? borderColor ?? Colors.blueGrey
                          : Colors.black,
                      width: borderSide ?? 1)),
              focusedBorder: noBorder
                  ? InputBorder.none
                  : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius ?? 6),
                  borderSide: BorderSide(
                      color: fillColor != null
                          ? borderColor ?? Colors.blueGrey
                          : Colors.black,
                      width: borderSide ?? 1)),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              prefix: prefix,
              suffix: suffix,
              labelText: label != null ? label + (required ? ' *' : '') : null,
              counterText: counterText,
              isDense: true,
              helperText: help,
              helperMaxLines: 5,
              helperStyle: helperStyle,
              errorText: errorText)));
}

Widget buildSelect(BuildContext context,
    {hint,
      List? selectedMenus,
      value,
      String? fieldValue,
      String? fieldLibelle,
      EdgeInsets? padding,
      Function? item,
      bool mandatory = false,
      int? maxLines,
      bool? isExpanded,
      TextStyle? style,
      Widget? icon,
      Color? borderColor,
      Color? dropdownColor,
      Color? bgColor,
      void Function(dynamic)? onChanged}) {
  if (selectedMenus == null) {
    return const SizedBox();
  }
  return DropdownButtonHideUnderline(
      child: Container(
          padding: padding ??
              const EdgeInsets.only(
                  left: 3.0, right: 3.0, top: 1.0, bottom: 1.0),
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                  color: borderColor ??
                      Colors.black)), //Theme.of(context).primaryColor
          child: DropdownButton(
              dropdownColor: dropdownColor,
              style: style ??
                  const TextStyle(fontSize: 14.0, color: Colors.black87),
              isExpanded: isExpanded ?? true,
              iconEnabledColor: style?.color,
              icon: icon,
              hint: hint is Widget
                  ? hint
                  : Text(hint ?? '',
                  maxLines: 1,
                  style: style ?? const TextStyle(color: Colors.black45,fontSize: 12.0)),//ll
              items: selectedMenus.map((value) {
                return DropdownMenuItem(
                    value: fieldValue != null ? value[fieldValue] : value,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: item != null
                            ? item(value)
                            : Text(
                            '${fieldLibelle != null ? value[fieldLibelle] : value}',
                            maxLines: maxLines ?? 2,
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis)));
              }).toList(),
              value: value,
              onChanged: onChanged)));
}

void showToast(BuildContext context, msg, {int seconds = 5}) {
  TextStyle textStyle = const TextStyle(fontSize: 13.0, color: Colors.white);
  showToastWidget(Builder(builder: (BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: const Color(0x99000000)),
        padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        child: msg is String
            ? Text(msg,
            textAlign: TextAlign.center,
            style: textStyle,
            // maxFontSize: 17,
            // minFontSize: 9,
            maxLines: 1)
            : msg);
  }),
      context: context,
      animation: StyledToastAnimation.slideFromBottom,
      reverseAnimation: StyledToastAnimation.fade,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeInOut,
      dismissOtherToast: true,
      duration: Duration(seconds: seconds),
      endOffset: const Offset(0, -2.5),
      animDuration: const Duration(milliseconds: 1500));
}

showLoading(context, [String? msg]) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 20.0),
            content: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 4),
              Expanded(
                  child: Text(msg ?? 'Chargement',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.center))
            ]));
      });
}