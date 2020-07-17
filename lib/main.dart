import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'file:///D:/Games/FlutterApp/myapp/stock_app/lib/pages/page_inventaire/page_inventaire.dart';
import 'package:testapp/models/produit.dart';
import 'package:testapp/models/inventaire.dart';
import 'package:testapp/database.dart';
import 'package:testapp/fonctions.dart';


void main() async {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ModelListInventaire(),),
          ChangeNotifierProvider(create: (context) => Inventaire(0, ""),),
          ChangeNotifierProvider(create: (context) => Produit(0, 0, "", 1),)
        ],
        child: MyApp(),
      )
  );
}


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    DBProvider.db.remplirListe(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,

        primaryColor: Colors.white,
        accentColor: const Color(0xfff70c36), // These are the color of the ISATI
        cardColor: Colors.white,

        appBarTheme: const AppBarTheme(
          // color: Colors.white,
          elevation: 0,
        ),

        fontFamily: "Futura Light",

        textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w800, color: Colors.black87),
            headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: Colors.black87),
            subtitle1: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w800, color: Colors.black87)
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes:{
        '/': (context) => PageInventaire(),
      },
    );
  }
}