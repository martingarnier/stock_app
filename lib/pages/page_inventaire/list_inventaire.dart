import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:testapp/fonctions.dart';
import 'package:testapp/models/inventaire.dart';
import 'package:testapp/pages/page_inventaire/bouton_inventaire.dart';

class ListeInventaire extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: Provider.of<ModelListInventaire>(context).listeInventaire.map((inventaire) {
        return ChangeNotifierProvider<Inventaire>.value(value: inventaire, child: BoutonInventaire(),);
      }).toList(),
    );
  }
}