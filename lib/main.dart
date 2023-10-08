import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Tasks"),
      ),
      body: ListView.builder(
        itemCount: 10, // Example count, you can replace this as needed
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Task $index'),
            subtitle: Text('Description for task $index'),
            trailing: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                // Placeholder interaction
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Placeholder interaction
        },
      ),
    );
  }
}
