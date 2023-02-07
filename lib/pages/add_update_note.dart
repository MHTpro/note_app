import 'package:flutter/material.dart';

import '../db/my_database.dart';
import '../models/database_model.dart';

class AddUpdatePage extends StatefulWidget {
  final Note? theNote;

  const AddUpdatePage({super.key, this.theNote});

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formkey = GlobalKey<FormState>();
  late String theTitle;
  late String theDescription;

  @override
  void initState() {
    theTitle = widget.theNote?.title ?? "";
    theDescription = widget.theNote?.description ?? "";
    super.initState();
  }

  Future updateThisNote() async {
    final newNote = widget.theNote!.copy(
      title: theTitle,
      description: theDescription,
    );
    await NoteDB.instance.updateNote(newNote);
  }

  Future addThisNote() async {
    final newNote = Note(
      title: theTitle,
      description: theDescription,
    );
    await NoteDB.instance.create(newNote);
  }

  Widget saveButton() {
    //check_validForm(color)
    final bool isValidFormColor =
        theTitle.isNotEmpty && theDescription.isNotEmpty;

    //
    return ElevatedButton(
      onPressed: () async {
        //check_validForm
        final validForm = _formkey.currentState!.validate();
        final backToData = Navigator.of(context);

        if (validForm) {
          //update_OR_add
          final isUpdating = widget.theNote != null;

          if (isUpdating) {
            //updating
            await updateThisNote();
          } else {
            //adding
            await addThisNote();
          }
          backToData.pop();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isValidFormColor ? Colors.blueAccent.shade700 : Colors.grey[700],
      ),
      child: const Text(
        "S A V E",
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent.shade700,
        title: const Text(
          "Note(Update,Add)",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 380.0,
                  width: 360.0,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //titleTXT
                      SizedBox(
                        height: 80.0,
                        width: 330.0,
                        child: TextFormField(
                          initialValue: theTitle,
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            filled: true,
                            fillColor: Colors.blueAccent.shade400,
                            labelText: "Title",
                            labelStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              color: Colors.black45,
                            ),
                          ),
                          onChanged: (value) {
                            setState(
                              () {
                                theTitle = value;
                              },
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter title!";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),

                      //DescriptionTXT
                      SizedBox(
                        height: 120.0,
                        width: 330.0,
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 3,
                          initialValue: theDescription,
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            filled: true,
                            fillColor: Colors.blueAccent.shade400,
                            labelText: "Description",
                            labelStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(
                              Icons.description,
                              color: Colors.black45,
                            ),
                          ),
                          onChanged: (value) {
                            setState(
                              () {
                                theDescription = value;
                              },
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Description!";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 45.0,
                ),
                saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
