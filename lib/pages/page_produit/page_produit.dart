import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:testapp/fonctions.dart';
import 'package:testapp/models/inventaire.dart';
import 'package:testapp/models/produit.dart';
import 'package:testapp/database.dart';
import 'package:testapp/pages/page_produit/boite_produit.dart';

class PageProduit extends StatelessWidget{

  final BuildContext contextInventaire;

  PageProduit(this.contextInventaire);

  @override
  Widget build(BuildContext context) {
    Color iColor = randomMaterialColor();
    Inventaire inventaire = Provider.of<Inventaire>(contextInventaire);
    String nouveauProduit = "";

    return ChangeNotifierProvider.value(
      value: inventaire,
      builder: (context, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              margin: EdgeInsets.all(10),
              child: AppBar(
                title: Consumer<Inventaire>(
                  builder: (context, i, child) {
                    return Text(i.nom, style: Theme.of(context).textTheme.headline1,);
                  },
                ),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (){alertChangerNomInventaire(context);},
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: (){alertSupprimerInventaire(context);},
                  ),
                ],
              ),
            ),
          ),
          body: GridView.extent(
            children: Provider.of<Inventaire>(context).produits.map((produit) {
              return ChangeNotifierProvider.value(value: produit, child: BoiteProduit(contextInventaire),);
            }).toList(),
            maxCrossAxisExtent: MediaQuery.of(context).size.width/2,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => {
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text("Entrez le nom du produit"),
                      content: TextField(
                        onChanged: (s) => nouveauProduit = s,
                        autofocus: true,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("No"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: () async {
                            if(nouveauProduit != "") inventaire.ajouter(new Produit(await DBProvider.db.getNextIdProduit(), inventaire.idInventaire, nouveauProduit, 1));
                            nouveauProduit = "";
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
              )
            },
            tooltip: 'Ajouter',
            child: Icon(Icons.add),
            backgroundColor: iColor,
            foregroundColor: contrastColor(iColor),
          ),
        );
      },
    );
  }

  void alertChangerNomInventaire(BuildContext context){
    String nouveauNomInventaire = "";

    showDialog(context: context,
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
                onPressed: (){
                  if(nouveauNomInventaire != ""){
                    Provider.of<Inventaire>(contextInventaire, listen: false).setNom(nouveauNomInventaire);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          );
        }
    );
  }

  void alertSupprimerInventaire(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Supprimer l'inventaire ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Provider.of<ModelListInventaire>(context, listen: false).supprimer(Provider.of<Inventaire>(contextInventaire, listen: false));
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
}