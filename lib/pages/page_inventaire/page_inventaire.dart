import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:testapp/fonctions.dart';
import 'package:testapp/models/inventaire.dart';
import 'package:testapp/database.dart';
import 'package:testapp/pages/page_inventaire/list_inventaire.dart';

class PageInventaire extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Color iColor = randomMaterialColor();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          margin: EdgeInsets.all(10),
          child: AppBar(
            title: Text('Stock', style: Theme.of(context).textTheme.headline1,),
            centerTitle: true,
          ),
        ),
      ),
      body: ListeInventaire(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          alertNouvelInventaire(context);
        },
        tooltip: 'Ajouter',
        child: Icon(Icons.add),
        backgroundColor: iColor,
        foregroundColor: contrastColor(iColor),
      ),
    );
  }

  void alertNouvelInventaire(BuildContext context) {
    String nouveauNomInventaire = "";

    showDialog (context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Entrez le nom de l'inventaire"),
            content: TextField(
              onChanged: (value) => nouveauNomInventaire = value,
              autofocus: true,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("Ok"),
                onPressed: () async {
                  if(nouveauNomInventaire != ""){
                    Provider.of<ModelListInventaire>(context, listen: false).ajouter(new Inventaire(await DBProvider.db.getNextIdInventaire() ,nouveauNomInventaire));
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        }
    );
  }
}