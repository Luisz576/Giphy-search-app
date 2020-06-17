import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:buscador_itens_app/ui/gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart' as KTransparentImage;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _searsh = "";
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    if (_searsh == null || _searsh.isEmpty) {
      response = await http.get(
          "http://api.giphy.com/v1/gifs/trending?api_key=3ZtOsomDyHlx5m1959lsFFTp1TLeyTZW&limit=20&rating=G");
    } else {
      response = await http.get(
          "http://api.giphy.com/v1/gifs/search?api_key=3ZtOsomDyHlx5m1959lsFFTp1TLeyTZW&q=$_searsh&limit=20&offset=$_offset%rating=G&lang=en");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onSubmitted: (text){
                setState(() {
                  _searsh = text;
                  _offset = 0;
                });
              },
              decoration: InputDecoration(
                labelText: "Pesquise aqui!",
                labelStyle: TextStyle(
                    color: Colors.white
                ),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                    break;
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                    break;
                }
              },
              future: _getGifs(),
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data){
    if(_searsh == "" || _searsh.isEmpty){
      return data.length;
    }else{
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //Maximo de itens na horizontal
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index){
        if(_searsh == "" || _searsh.isEmpty || index < snapshot.data['data'].length){
          return GestureDetector( //Permite clicar
            child: FadeInImage.memoryNetwork(
                placeholder: KTransparentImage.kTransparentImage,
                image: snapshot.data['data'][index]['images']['fixed_height']['url'],
                height: 300.0,
                width: 300.0,
                fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => GifPage(snapshot.data['data'][index]),
                )
              );
            },
            onLongPress: (){
              Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
            },
          );
        }else{
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Load more...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 20;
                });
              },
            ),
          );
        }
      },
      itemCount: _getCount(snapshot.data['data']),
    );
  }

}