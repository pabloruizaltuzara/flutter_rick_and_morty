import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:consumi_api_flutter/datos.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(App());
}

class App extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {


  late Future<List<Personaje>> _listadoPersonajes ;

  Future<List<Personaje>> _getPersonajes() async {
    final response = await http.get(Uri.parse("https://rickandmortyapi.com/api/character"));


    List<Personaje> personajes=[];

    if(response.statusCode == 200){

      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      
      for (var item in jsonData["results"]){
        personajes.add(Personaje(item["name"], item["status"], item["species"], item["image"]));
      }
      
      return personajes;

    }else{
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoPersonajes=_getPersonajes();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumo api',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ricky and Morty'),
        ),
        body:FutureBuilder(
          future: _listadoPersonajes,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView(
                children: _listGifs(snapshot.data as List<Personaje>),
              );
            }else if(snapshot.hasError){
              return const Text('error');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      )
    );
  }

  List<Widget> _listGifs(List<Personaje> data){
    List<Widget> personajes=[];

    for (var personaje in data ){
      personajes.add(ListTile(
                      leading: FadeInImage(
                        image: NetworkImage(personaje.image),
                        placeholder: const NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQG9Q4-7ovwf0FXsPOOOKnATIaCZ6PvQeCzB0FbiwCJN5q0CvGeLPxa76BQwyw4bHi5apo&usqp=CAU"),
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                      title: Text(personaje.name, style: const TextStyle(
                          color: Color.fromARGB(255, 25, 38, 48),
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          
                          Text("Estado: ${personaje.status}", style: const TextStyle(
                              color: Color.fromARGB(255, 14, 90, 52),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 25.0,
                          ),
                          Text("Espec: ${personaje.species}", style: const TextStyle(
                              color: Color.fromARGB(255, 165, 16, 16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                    ));
    }
    return personajes;
  }

}