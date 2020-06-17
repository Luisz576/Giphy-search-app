import 'package:flutter/material.dart';

import 'package:buscador_itens_app/ui/HomePage.dart';

String _title = "Buscador de gifs";

void main(){
  runApp(MaterialApp(
    title: _title,
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.white,
    ),
  ));
}