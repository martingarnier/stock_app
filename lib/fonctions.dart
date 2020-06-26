import 'dart:math';
import 'package:flutter/material.dart';

import 'package:testapp/models/inventaire.dart';
import 'package:testapp/database.dart';


class ModelListInventaire extends ChangeNotifier{
  List<Inventaire> listeInventaire = [];

  ModelListInventaire();

  void ajouter(Inventaire i){
    listeInventaire.add(i);
    DBProvider.db.insererInventaire(i);
    notifyListeners();
  }

  void supprimer(Inventaire i){
    listeInventaire.remove(i);
    DBProvider.db.supprimerInventaire(i.id_inventaire);
    notifyListeners();
  }

  int getIndiceInventaire(Inventaire i){
    return listeInventaire.indexOf(i);
  }
}


Color contrastColor(Color iColor)
{
  // Calculate the perceptive luminance (aka luma) - human eye favors green color...
  final double luma = ((0.299 * iColor.red) + (0.587 * iColor.green) + (0.114 * iColor.blue)) / 255;

  // Return black for bright colors, white for dark colors
  return luma > 0.5 ? Colors.black : Colors.white;
}

Color randomMaterialColor()
{
  return Colors.primaries[Random().nextInt(Colors.primaries.length)];
}