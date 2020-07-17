import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/fonctions.dart';
import 'package:testapp/models/inventaire.dart';
import 'package:testapp/models/produit.dart';

class BoiteProduit extends StatelessWidget{

  Produit p;
  final BuildContext contextInventaire;

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