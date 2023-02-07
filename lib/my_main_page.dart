import 'package:flutter/material.dart';
import 'package:test_flutter_app/pages/add_update_note.dart';
import 'package:test_flutter_app/pages/view_delete_note.dart';

import './db/my_database.dart';
import './models/database_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Note?>? allNotes;
  bool isLoading = false;

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  void dispose() {
    NoteDB.instance.closeDB();
    super.dispose();
  }

  Future refreshData() async {
    setState(() => isLoading = true);
    NoteDB.instance.readAll().then((v) => allNotes = v);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const AddUpdatePage();
              },
            ),
          );
          refreshData();
        },
        backgroundColor: Colors.blueAccent.shade700,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
        title: const Text(
          "Note App",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: NoteDB.instance.readAll(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          //DB == NULL || Loading
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                height: 100.0,
                width: 100.0,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.white38,
                  strokeWidth: 10.0,
                ),
              ),
            );
          }
          return isLoading
              ? const CircularProgressIndicator()
              : allNotes!.isEmpty
                  ? const Center(
                      child: Text(
                        "Click (+) To Create",
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: allNotes!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ViewTheNote(
                                        noteId: allNotes![index]!.id);
                                  },
                                ),
                              );
                              refreshData();
                            },
                            child: SingleChildScrollView(
                              child: Container(
                                alignment: Alignment.center,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade700,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  "(< ${allNotes![index]!.title} >)",
                                  style: const TextStyle(
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }
}
