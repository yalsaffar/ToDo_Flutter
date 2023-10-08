import 'package:flutter/material.dart';
import 'task.dart';
import 'task_screen.dart';
import 'completed_tasks_screen.dart';
import 'new_task_sheet.dart';
import 'task_details_page.dart';
import 'utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false, // Removing the debug banner
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        hintColor: Colors.amber,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 16),
          bodyText2: TextStyle(fontSize: 14),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  List<Task> completedTasks = [];

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void updateTask(int index, Task newTask) {
    setState(() {
      tasks[index] = newTask;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return WideLayout(
            tasks: tasks,
            completedTasks: completedTasks,
            onAddTask: addTask,
            onUpdateTask: updateTask,
            onDeleteTask: deleteTask,
            onCompleteTask: completeTask,
            onUncompleteTask: uncompleteTask,
          );
        } else {
          return NarrowLayout(
            tasks: tasks,
            completedTasks: completedTasks,
            onAddTask: addTask,
            onUpdateTask: updateTask,
            onDeleteTask: deleteTask,
            onCompleteTask: completeTask,
            onUncompleteTask: uncompleteTask,
          );
        }
      },
    );
  }
}


class WideLayout extends StatelessWidget {
  final List<Task> tasks;
  final List<Task> completedTasks;
  final Function(Task) onAddTask;
  final Function(int, Task) onUpdateTask;
  final Function(int) onDeleteTask;
  final Function(int) onCompleteTask;
  final Function(int) onUncompleteTask;

  WideLayout({
    required this.tasks,
    required this.completedTasks,
    required this.onAddTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
    required this.onCompleteTask,
    required this.onUncompleteTask,
  });

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            child: TaskScreen(
              tasks: tasks,
              onAddTask: onAddTask,
              onCompleteTask: onCompleteTask,
              onUpdateTask: onUpdateTask,
              onDeleteTask: onDeleteTask,
            ),
          ),
          VerticalDivider(color: Colors.grey[300], width: 1.0),
          Expanded(
            child: CompletedTasksScreen(
              completedTasks: completedTasks,
              onUncompleteTask: onUncompleteTask,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Task'),
        icon: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => NewTaskSheet(
              onAddTask: onAddTask,
            ),
          );
        },
      ),
    );
  }
}


class NarrowLayout extends StatefulWidget {
  final List<Task> tasks;
  final List<Task> completedTasks;
  final Function(Task) onAddTask;
  final Function(int, Task) onUpdateTask;
  final Function(int) onDeleteTask;
  final Function(int) onCompleteTask;
  final Function(int) onUncompleteTask;

  NarrowLayout({
    required this.tasks,
    required this.completedTasks,
    required this.onAddTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
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
        centerTitle: true,
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
              onUpdateTask: widget.onUpdateTask,
              onDeleteTask: widget.onDeleteTask,
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Task'),
        icon: Icon(Icons.add),
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

