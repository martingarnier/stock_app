import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:testapp/fonctions.dart';
import 'package:testapp/models/inventaire.dart';
import 'package:testapp/models/produit.dart';
import 'package:testapp/database.dart';

class PageProduit extends StatelessWidget{

  BuildContext contextInventaire;

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
                            if(nouveauProduit != "") inventaire.ajouter(new Produit(await DBProvider.db.getNextIdProduit(), inventaire.id_inventaire, nouveauProduit, 1));
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



class BoiteProduit extends StatelessWidget{

  Produit p;
  BuildContext contextInventaire;

  BoiteProduit(this.contextInventaire);

  @override
  Widget build(BuildContext context) {
    Color iColor = randomMaterialColor();
    p = Provider.of<Produit>(context);

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
        color: Colors.white,
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                height: MediaQuery.of(context).size.height/4,
                child: Consumer<Produit>(
                  builder: (context, produit, child) {
                    return Text(produit.nom, style: Theme.of(context).textTheme.headline3,);
                  },
                ),
              ),
            ),
            Expanded(
              child: Consumer<Produit>(
                builder: (context, produit, child){
                  return Text('Quantité : ${produit.quantite}', style: Theme.of(context).textTheme.headline4,);
                },
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          p.quantite != 1 ? p.decrementer() : alertSupprimerProduit(context);
                        },
                        icon: Icon(Icons.remove),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          p.incrementer();
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                    Expanded(
                        child: Consumer<Produit>(
                          builder: (context, value, child) {
                            return IconButton(
                              onPressed: () {
                                alertChangerNomProduit(context);
                              },
                              icon: Icon(Icons.edit),
                            );
                          },
                        )
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void alertSupprimerProduit(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Supprimer le produit ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Provider.of<Inventaire>(contextInventaire, listen: false).supprimer(p);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  void alertChangerNomProduit(BuildContext context){
    String nouveauNomProduit = "";

    showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Entrez le nom du produit"),
            content: TextField(
              onChanged: (value) => nouveauNomProduit = value,
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
                  if(nouveauNomProduit != ""){
                    p.setNom(nouveauNomProduit);
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