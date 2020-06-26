import 'package:flutter/material.dart';

import 'package:testapp/models/produit.dart';
import 'package:testapp/database.dart';

class Inventaire extends ChangeNotifier{

  int _id_inventaire;
  String _nom;
  List<Produit> _produits;

  int get id_inventaire => _id_inventaire;
  String get nom => _nom;
  List<Produit> get produits => _produits;

  Inventaire(this._id_inventaire, this._nom){
    _produits = new List<Produit>();
  }

  void setNom(String s){
    _nom = s;
    DBProvider.db.updateInventaire(this);
    notifyListeners();
  }

  void ajouter(Produit p){
    _produits.add(p);
    DBProvider.db.insererProduit(p);
    notifyListeners();
  }

  void supprimer(Produit p){
    _produits.remove(p);
    DBProvider.db.supprimerProduit(p.id_produit);
    notifyListeners();
  }

  Map<String, dynamic> toMap(){
    return{
      'id_inventaire': _id_inventaire,
      'nom_inventaire': _nom,
    };
  }
}