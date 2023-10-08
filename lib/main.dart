import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Task> tasks = [];
  List<Task> completedTasks = [];

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void completeTask(int index) {
    setState(() {
      Task completedTask = tasks.removeAt(index);
      completedTask.isCompleted = true;
      completedTasks.add(completedTask);
    });
  }

  void uncompleteTask(int index) {
    setState(() {
      Task task = completedTasks.removeAt(index);
      task.isCompleted = false;
      tasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return WideLayout(
              tasks: tasks,
              completedTasks: completedTasks,
              onAddTask: addTask,
              onCompleteTask: completeTask,
              onUncompleteTask: uncompleteTask,
            );
          } else {
            return NarrowLayout(
              tasks: tasks,
              completedTasks: completedTasks,
              onAddTask: addTask,
              onCompleteTask: completeTask,
              onUncompleteTask: uncompleteTask,
            );
          }
        },
      ),
    );
  }
}

class WideLayout extends StatelessWidget {
  final List<Task> tasks;
  final List<Task> completedTasks;
  final Function(Task) onAddTask;
  final Function(int) onCompleteTask;
  final Function(int) onUncompleteTask;

  WideLayout({
    required this.tasks,
    required this.completedTasks,
    required this.onAddTask,
    required this.onCompleteTask,
    required this.onUncompleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: TaskScreen(
              tasks: tasks,
              onAddTask: onAddTask,
              onCompleteTask: onCompleteTask,
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: CompletedTasksScreen(
              completedTasks: completedTasks,
              onUncompleteTask: onUncompleteTask,
            ),
          ),
        ],
      ),
    );
  }
}

class NarrowLayout extends StatefulWidget {
  final List<Task> tasks;
  final List<Task> completedTasks;
  final Function(Task) onAddTask;
  final Function(int) onCompleteTask;
  final Function(int) onUncompleteTask;

  NarrowLayout({
    required this.tasks,
    required this.completedTasks,
    required this.onAddTask,
    required this.onCompleteTask,
    required this.onUncompleteTask,
  });

  @override
  _NarrowLayoutState createState() => _NarrowLayoutState();
}

class _NarrowLayoutState extends State<NarrowLayout> {
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showCompleted ? "Completed Tasks" : "Pending Tasks"),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                showCompleted = !showCompleted;
              });
            },
          )
        ],
      ),
      body: showCompleted
          ? CompletedTasksScreen(
              completedTasks: widget.completedTasks,
              onUncompleteTask: widget.onUncompleteTask,
            )
          : TaskScreen(
              tasks: widget.tasks,
              onAddTask: widget.onAddTask,
              onCompleteTask: widget.onCompleteTask,
            ),
      floatingActionButton: showCompleted
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => NewTaskSheet(
                    onAddTask: widget.onAddTask,
                  ),
                );
              },
            ),
    );
  }
}

class TaskScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onAddTask;
  final Function(int) onCompleteTask;

  TaskScreen({
    required this.tasks,
    required this.onAddTask,
    required this.onCompleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: Icon(Icons.check),
            onPressed: () => onCompleteTask(index),
          ),
        );
      },
    );
  }
}

class CompletedTasksScreen extends StatelessWidget {
  final List<Task> completedTasks;
  final Function(int) onUncompleteTask;

  CompletedTasksScreen({
    required this.completedTasks,
    required this.onUncompleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: completedTasks.length,
      itemBuilder: (ctx, index) {
        final task = completedTasks[index];
        return ListTile(
          title: Text(task.title, style: TextStyle(decoration: TextDecoration.lineThrough)),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: Icon(Icons.undo),
            onPressed: () => onUncompleteTask(index),
          ),
        );
      },
    );
  }
}

class NewTaskSheet extends StatefulWidget {
  final Function(Task) onAddTask;

  NewTaskSheet({required this.onAddTask});

  @override
  _NewTaskSheetState createState() => _NewTaskSheetState();
}

class _NewTaskSheetState extends State<NewTaskSheet> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime dueDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          // Simple DatePicker (This can be enhanced)
          ElevatedButton(
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (selectedDate != null) {
                setState(() {
                  dueDate = selectedDate;
                });
              }
            },
            child: Text("Select Due Date"),
          ),
          ElevatedButton(
            onPressed: () {
              Task newTask = Task(
                title: titleController.text,
                description: descriptionController.text,
                dueDate: dueDate,
              );
              widget.onAddTask(newTask);
              Navigator.pop(context);
            },
            child: Text("Add Task"),
          ),
        ],
      ),
    );
  }
}
