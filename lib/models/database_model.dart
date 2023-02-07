//table_name
const String notesTable = "note";

//get_data_of_fields
class Note {
  final int? id;
  final String? title;
  final String? description;

  const Note({
    this.id,
    this.title,
    this.description,
  });

  //convert_to_json
  Map<String, Object?> toJson() {
    return {
      NoteFields.id: id,
      NoteFields.title: title,
      NoteFields.description: description,
    };
  }

  //json_to_dart(OBJ)
  static Note fromJson(Map<String, Object?> json) {
    return Note(
      id: json[NoteFields.id] as int?,
      title: json[NoteFields.title] as String?,
      description: json[NoteFields.description] as String?,
    );
  }

  //send_to_DB
  Note copy({
    int? id,
    String? title,
    String? description,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

//name_of_field_in_table
class NoteFields {
  static const List<String> values = [
    id,
    title,
    description,
  ];
  static const String id = '_id';
  static const String title = '_title';
  static const String description = '_description';
}
