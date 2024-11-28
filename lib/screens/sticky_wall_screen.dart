import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StickyWallScreen extends StatefulWidget {
  @override
  _StickyWallScreenState createState() => _StickyWallScreenState();
}

class _StickyWallScreenState extends State<StickyWallScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchStickyNotes(); 
  }

  // Fetch sticky notes from Firebase
  Future<void> _fetchStickyNotes() async {
    try {
      final snapshot = await _firestore.collection('sticky_notes').get();
      setState(() {
        notes = snapshot.docs.map((doc) => doc['content'] as String).toList();
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  // Add a sticky note to Firebase
  Future<void> _addStickyNoteToFirebase(String noteContent) async {
    try {
      await _firestore.collection('sticky_notes').add({'content': noteContent});
      setState(() {
        notes.add(noteContent);
      });
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  // Delete a sticky note from Firebase
  Future<void> _deleteStickyNoteFromFirebase(int index) async {
    try {
      final snapshot = await _firestore.collection('sticky_notes').get();
      final docId = snapshot.docs[index].id;
      await _firestore.collection('sticky_notes').doc(docId).delete();
      setState(() {
        notes.removeAt(index);
      });
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  // Show dialog for adding a new sticky note
  void _addStickyNote() {
  TextEditingController _controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), 
        ),
        title: Text(
          'New Sticky Note',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 400, 
          height: 200, 
          child: TextField(
            controller: _controller,
            maxLines: null, // 
            expands: true, 
            decoration: InputDecoration(
              hintText: 'Enter your note',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                await _addStickyNoteToFirebase(_controller.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sticky Wall',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: notes.isEmpty
            ? Center(child: Text('No sticky notes yet.'))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(notes[index]),
                    onDismissed: (direction) async {
                      await _deleteStickyNoteFromFirebase(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sticky Note deleted')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    child: Card(
                      color: Colors.yellow[100],
                      child: Center(
                        child: ListTile(
                          title: Text(
                            notes[index],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          leading: Icon(Icons.note, color: Colors.brown),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStickyNote,
        child: Icon(Icons.add),
        tooltip: 'Add Sticky Note',
      ),
    );
  }
}
