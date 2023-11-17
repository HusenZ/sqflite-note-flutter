import 'dart:convert';

class Note {
  final int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._id, this._title, this._date, this._priority,
      {String description = ''})
      : _description = description;

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      '_title': _title,
      '_description': _description,
      '_date': _date,
      '_priority': _priority,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      map['_id'] ?? 0,
      map['_title'] ?? '',
      map['_date'] ?? '',
      map['_priority'] ?? 0,
      description: map['_description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}
