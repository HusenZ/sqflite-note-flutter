import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite_notekeeper/model/note_model.dart';
import 'package:sqflite_notekeeper/screens/add_note.dart';
import 'package:sqflite_notekeeper/utils/db_helper.dart';
import 'package:sqflite_notekeeper/widgets/snack_bar.dart';
import '../utils/ui_utils.dart';

class NoteLists extends StatefulWidget {
  const NoteLists({super.key});

  @override
  State<NoteLists> createState() => _NoteListsState();
}

class _NoteListsState extends State<NoteLists> {
  DBHelper dataBaseHelper = DBHelper();
  List<Note> noteList = [];
  int count = 0;

  void delete(Note note) async {
    int reslut = await dataBaseHelper.deleteNote(note.id);
    if (reslut != 0) {
      updateListView();
      // ignore: use_build_context_synchronously
      showCustomSnackbar(context, 'Deleted Successfully');
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = dataBaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dataBaseHelper.getNote();
      noteListFuture.then((newNoteList) {
        setState(() {
          noteList = newNoteList;
          count = newNoteList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5.0,
      ),
      body: getNotesListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(
                note: Note(1, '', '', 2),
              ),
            ),
          );
          debugPrint('Fab clicked');
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  ListView getNotesListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[index].priority),
              child: getPriorityIcon(noteList[index].priority),
            ),
            title: Text(noteList[index].title),
            subtitle: Text(noteList[index].date),
            trailing: InkWell(
              onTap: () {
                delete(noteList[index]);
              },
              child: const Icon(
                Icons.delete,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddNoteScreen(
                    note: noteList[index],
                  ),
                ),
              );
              debugPrint('List tapped');
            },
          ),
        );
      },
    );
  }
}
