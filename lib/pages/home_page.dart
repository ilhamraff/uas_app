import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  final user = FirebaseAuth.instance.currentUser!;

  late Future<List<Game>> futureGames;

  @override
  void initState() {
    super.initState();
    futureGames = fetchGames();
  }

  Future<List<Game>> fetchGames() async {
    final response =
        await http.get(Uri.parse('https://www.freetogame.com/api/games'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Game> games = data.map((item) => Game.fromJson(item)).toList();
      return games;
    } else {
      throw Exception('Failed to load games');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Discover "),
        backgroundColor: Color.fromRGBO(83, 33, 43, 1),
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            children: [
              DrawerHeader(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Logged In As : ',
                      style: GoogleFonts.bebasNeue(fontSize: 20),
                    ),
                    Text(
                      user.email!,
                      style: GoogleFonts.bebasNeue(fontSize: 20),
                    ),
                  ],
                ),
              )),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Logout',
                  style: GoogleFonts.montserrat(fontSize: 20),
                ),
                onTap: () {
                  showLogoutConfirmationDialog(context);
                },
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Game>>(
        future: futureGames,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        vertical: 8.0), // Memberikan jarak vertikal antar card
                    child: Padding(
                      padding: EdgeInsets.all(
                          16.0), // Memberikan jarak antara konten dalam card
                      child: ListTile(
                        leading: Image(
                          image: NetworkImage(
                              snapshot.data![index].thumbnail.toString()),
                          fit: BoxFit.fill,
                        ),
                        title: Text(snapshot.data![index].title),
                        subtitle: Text(
                          'Genre: ${snapshot.data![index].genre}\nPlatform: ${snapshot.data![index].platform}',
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                // Panggil fungsi signUserOut di sini
                signUserOut();
                // Tutup dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
