import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/fonctions.dart';
import 'package:testapp/models/inventaire.dart';
import 'package:testapp/pages/page_produit/page_produit.dart';

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