import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StickyWallScreen extends StatefulWidget {
  @override
  _StickyWallScreenState createState() => _StickyWallScreenState();
}

class _StickyWallScreenState extends State<StickyWallScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> notes = [];
  List<String> noteIds = [];
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _fetchStickyNotes();
  }


  Future<void> _fetchStickyNotes() async {
    setState(() {
      _isLoading = true; 
    });

    try {
      final snapshot = await _firestore.collection('sticky_notes').get();
      setState(() {
        notes = snapshot.docs.map((doc) => doc['content'] as String).toList();
        noteIds = snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching notes: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  
  Future<void> _addStickyNoteToFirebase(String noteContent) async {
    try {
      final docRef = await _firestore.collection('sticky_notes').add({'content': noteContent});
      setState(() {
        notes.add(noteContent);
        noteIds.add(docRef.id);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding note: $e')),
      );
    }
  }


  Future<void> _deleteStickyNoteFromFirebase(int index) async {
    try {
      await _firestore.collection('sticky_notes').doc(noteIds[index]).delete();
      setState(() {
        notes.removeAt(index);
        noteIds.removeAt(index);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting note: $e')),
      );
    }
  }

  
  void _addStickyNote() {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            'New Sticky Note',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            height: 200,
            child: TextField(
              controller: _controller,
              maxLines: null, 
              expands: true,
              decoration: InputDecoration(
                hintText: 'Enter your note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.all(10.0),
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
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: notes.isEmpty
                  ? const Center(
                      child: Text(
                        'No sticky notes yet.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(noteIds[index]),
                          onDismissed: (direction) async {
                            await _deleteStickyNoteFromFirebase(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sticky Note deleted')),
                            );
                          },
                          background: Container(
                            color: Colors.red,
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
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
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                leading: const Icon(Icons.note, color: Colors.brown),
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
