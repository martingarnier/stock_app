import 'package:flutter/material.dart';

import 'package:testapp/database.dart';

class Produit extends ChangeNotifier {

  int _id_produit;
  int _id_inventaire;
  String _nom;
  int _quantite;

  int get id_produit => _id_produit;
  int get id_inventaire => _id_inventaire;
  String get nom => _nom;
  int get quantite => _quantite;

  Produit(this._id_produit, this._id_inventaire, this._nom, this._quantite);

  void setNom(String s){
    _nom = s;
    DBProvider.db.updateProduit(this);
    notifyListeners();
  }

  void incrementer(){
    _quantite++;
    DBProvider.db.updateProduit(this);
    notifyListeners();
  }

  void decrementer(){
    _quantite--;
    DBProvider.db.updateProduit(this);
    notifyListeners();
  }

  Map<String, dynamic> toMap(){
    return {
      'id_produit': _id_produit,
      'id_inventaire': _id_inventaire,
      'nom_produit': nom,
      'quantite': quantite
    };
  }
}