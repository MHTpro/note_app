import 'package:flutter/material.dart';
import 'package:test_flutter_app/pages/add_update_note.dart';

import '../db/my_database.dart';
import '../models/database_model.dart';

class ViewTheNote extends StatefulWidget {
  final int? noteId;
  const ViewTheNote({super.key, required this.noteId});

  @override
  State<ViewTheNote> createState() => _ViewTheNoteState();
}

class _ViewTheNoteState extends State<ViewTheNote> {
  late Note theNote;
  late List<Note> allNotes;
  bool isloading = false;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  Future refresh() async {
    setState(() => isloading = true);
    theNote = await NoteDB.instance.readPost(widget.noteId);
    setState(() => isloading = false);
  }

  Future refreshAllData() async {
    setState(() => isloading = true);
    NoteDB.instance.readAll().then((v) => allNotes = v);
    setState(() => isloading = false);
  }

  Widget editButtonMethod() {
    return IconButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AddUpdatePage(
                theNote: theNote,
              );
            },
          ),
        );
        refresh();
      },
      icon: const Icon(
        Icons.edit,
        color: Colors.green,
        size: 33.0,
      ),
    );
  }

  Widget deleteButtonMethod() {
    final backtoData = Navigator.of(context);
    return IconButton(
      onPressed: () async {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.blue.shade500,
              content: const Text(
                "Are you sure to Delete this note?",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                "Alert",
                style: TextStyle(
                  fontSize: 29.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await NoteDB.instance.deleteNote(theNote.id);
                    refreshAllData();
                    backtoData.pop();
                    backtoData.pop();
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    backtoData.pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(
        Icons.delete,
        size: 33.0,
        color: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
        title: const Text(
          "Your Note",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: isloading
          ? const CircularProgressIndicator()
          : Center(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                alignment: Alignment.center,
                height: 500.0,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade700,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "TITLE: ${theNote.title}",
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Divider(
                      color: Colors.white30,
                      thickness: 5.0,
                      height: 20.0,
                      endIndent: 20.0,
                      indent: 20.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "DESCRIPTION:\n ${theNote.description}",
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        editButtonMethod(),
                        deleteButtonMethod(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
