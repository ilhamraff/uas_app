import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uas_app/pages/firestore.dart';

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _JSONTestState();
}

class _JSONTestState extends State<Display> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();

  void openAddBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        firestoreService.addGame(textController.text);
                      } else {
                        firestoreService.updateGame(docID, textController.text);
                      }
                      textController.clear();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(83, 33, 43, 1)),
                    child: const Text('Submit'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('My WishList')),
        backgroundColor: Color.fromRGBO(83, 33, 43, 1),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddBox,
        backgroundColor: Color.fromRGBO(83, 33, 43, 1),
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getGameStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List gameList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: gameList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = gameList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String gameText = data['game'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.videogame_asset_sharp),
                          title: Text(gameText),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => openAddBox(docID: docID),
                                icon: Icon(Icons.settings),
                              ),
                              IconButton(
                                onPressed: () => showDeleteConfirmationDialog(
                                    context, docID),
                                icon: Icon(Icons.done),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text("No Game = No Life");
            }
          }),
    );
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String docID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Already Done ? '),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Done'),
              onPressed: () {
                // Panggil fungsi deleteGame di sini
                firestoreService.deleteGame(docID);

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
