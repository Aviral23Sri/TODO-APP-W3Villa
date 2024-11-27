import 'package:flutter/material.dart';

class StickyWallScreen extends StatefulWidget {
  @override
  _StickyWallScreenState createState() => _StickyWallScreenState();
}

class _StickyWallScreenState extends State<StickyWallScreen> {
  List<String> notes = ['Aviral Srivastav' ,'cfhwe fhwi fwf b '];

  // Method to show a dialog for adding a new sticky note
  void _addStickyNote() {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Sticky Note'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter your note'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    notes.add(_controller.text);
                  });
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

  // Method to delete a sticky note
  void _deleteStickyNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
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
                    onDismissed: (direction) {
                      _deleteStickyNote(index);

                      // Show a snackbar to confirm deletion
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sticky Note deleted')),
                      );
                    },
                    background: Container(
                      color: Colors.red,  // Red background when swiping
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
