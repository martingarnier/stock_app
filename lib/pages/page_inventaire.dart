import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:testapp/pages/page_produit.dart';
import 'package:testapp/fonctions.dart';
import 'package:testapp/models/inventaire.dart';
import 'package:testapp/database.dart';

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


class BoutonInventaire extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Color iColor = randomMaterialColor();

    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(left: 10),
          color: Colors.white,
          height: 100,
          alignment: Alignment.center,
          child: ListTile(
            leading: Consumer<ModelListInventaire>(
              builder: (context, listeInventaire, child) {
                return Text(
                  '#${listeInventaire.getIndiceInventaire(Provider.of<Inventaire>(context)) + 1}',
                  style: Theme.of(context).textTheme.headline2,
                );
              },
            ),
            title: Consumer<Inventaire>(
              builder: (context, inventaire, child) {
                return Text(inventaire.nom, style: Theme.of(context).textTheme.headline2,);
              },
            ),
            trailing: Icon(Icons.keyboard_arrow_right, size: 50,),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (newContext) => PageProduit(context),
                  )
              );
            },
          ),
        )
    );
  }
}