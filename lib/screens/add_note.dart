import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sqflite_notekeeper/model/note_model.dart';
import 'package:sqflite_notekeeper/utils/db_helper.dart';
import 'package:sqflite_notekeeper/widgets/custom_textfield.dart';
import 'package:sqflite_notekeeper/widgets/snack_bar.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({
    Key? key,
    required this.note,
  }) : super(key: key);
  final Note note;
  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _priorities = ['high', 'low'];

  final helper = DBHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void updatePriorityAsInt(String value, Note note) {
    switch (value) {
      case 'High':
        note.priority = 1;
      case 'Low':
        note.priority = 2;
    }
  }

  String getPriorityAsString(int value, Note note) {
    String priority = 'Low';
    switch (value) {
      case 1:
        priority = _priorities[0];
      case 2:
        priority = _priorities[1];
    }
    return priority;
  }

  void updateTitle() {
    widget.note.title = titleController.text;
  }

  void updateDescription() {
    widget.note.description = descriptionController.text;
  }

  void save() async {
    widget.note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    // ignore: unnecessary_null_comparison
    if (widget.note.id != null) {
      result = await helper.updateNote(widget.note);
    } else {
      result = await helper.insertNote(widget.note);
    }
    if (result != 0) {
      // ignore: use_build_context_synchronously
      showCustomSnackbar(context, 'Successefully updated');
    } else {
      // ignore: use_build_context_synchronously
      showCustomSnackbar(context, 'Failed to update');
    }
  }

  void delete() async {
    int result = await helper.deleteNote(widget.note.id);
    if (result != 0) {
      // ignore: use_build_context_synchronously
      showCustomSnackbar(context, 'Successefully Deleted');
    } else {
      // ignore: use_build_context_synchronously
      showCustomSnackbar(context, 'Failed to Delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    Note note = widget.note;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          left: 10.0,
          right: 10.0,
        ),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDounStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDounStringItem,
                    child: Text(dropDounStringItem),
                  );
                }).toList(),
                value: getPriorityAsString(note.priority, note),
                onChanged: (value) {
                  setState(() {
                    debugPrint('User Seletce $value');
                    updatePriorityAsInt(value!, note);
                  });
                },
              ),
            ),
            CustomTextInput(
              titleController: titleController,
              onChanged: updateDescription,
              hintText: 'Enter title here',
            ),
            CustomTextInput(
              titleController: descriptionController,
              onChanged: updateTitle,
              hintText: 'Enter description here',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isEmpty) {
                          showCustomSnackbar(
                              context, 'Enter Title to add a note');
                        } else {
                          save();
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isEmpty) {
                          showCustomSnackbar(
                              context, 'Select some note to delete.');
                        } else {
                          delete();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
