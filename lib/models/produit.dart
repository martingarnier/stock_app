import 'package:flutter/material.dart';

import 'package:testapp/database.dart';

class Produit extends ChangeNotifier {

  int _idProduit;
  int _idInventaire;
  String _nom;
  int _quantite;

  int get idProduit => _idProduit;
  int get idInventaire => _idInventaire;
  String get nom => _nom;
  int get quantite => _quantite;

  Produit(this._idProduit, this._idInventaire, this._nom, this._quantite);

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
      'id_produit': _idProduit,
      'id_inventaire': _idInventaire,
      'nom_produit': nom,
      'quantite': quantite
    };
  }
}