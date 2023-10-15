// Carlo:
import 'dart:async';
import 'package:flutter/material.dart';
import 'task.dart';
import 'task_screen.dart';
import 'completed_tasks_screen.dart';
import 'new_task_sheet.dart';
import 'package:lottie/lottie.dart';
import 'instructions_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        hintColor: Colors.deepPurple,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 16),
          bodyText2: TextStyle(fontSize: 14),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      routes: {
          '/': (context) => SplashScreen(),
          '/instructions': (context) => InstructionsScreen(),
          '/home': (context) => HomeScreen(),
},

    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController)
      ..addListener(() {
        setState(() {});
      });

    _fadeController.forward();

    Future.delayed(const Duration(seconds: 5)).then((_) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => InstructionsScreen()));
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 135, 85, 201), Color.fromARGB(255, 69, 27, 117)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to my ToDo App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              Opacity(
                opacity: _fadeAnimation.value,
                child: Lottie.asset('assets/loading.json', width: 250, height: 250), // Ensure you have a Lottie file named loading.json in your assets folder
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // To keep track of the active screen
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

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Wide layout
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemSelected,
                  labelType: NavigationRailLabelType.selected,
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.list),
                      selectedIcon: const Icon(Icons.list, color: Colors.deepPurple),
                      label: const Text('Tasks'),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.check_circle_outline),
                      selectedIcon: const Icon(Icons.check_circle, color: Colors.deepPurple),
                      label: const Text('Completed'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _selectedIndex == 0
                      ? TaskScreen(
                          tasks: tasks,
                          onAddTask: addTask,
                          onCompleteTask: completeTask,
                          onUpdateTask: updateTask,
                          onDeleteTask: deleteTask,
                        )
                      : CompletedTasksScreen(
                          completedTasks: completedTasks,
                          onUncompleteTask: uncompleteTask,
                        ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => NewTaskSheet(onAddTask: addTask),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        } else {
          // Narrow layout
          List<Widget> _screens = [
            TaskScreen(
              tasks: tasks,
              onAddTask: addTask,
              onCompleteTask: completeTask,
              onUpdateTask: updateTask,
              onDeleteTask: deleteTask,
            ),
            CompletedTasksScreen(
              completedTasks: completedTasks,
              onUncompleteTask: uncompleteTask,
            ),
          ];

          return Scaffold(
            appBar: AppBar(title: _selectedIndex == 0 ? const Text('Tasks') : const Text('Completed Tasks')),
            body: _screens[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemSelected,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Completed'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => NewTaskSheet(onAddTask: addTask),
                );
              },
              child: const Icon(Icons.add),
            ),
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

  const WideLayout({
    Key? key,
    required this.tasks,
    required this.completedTasks,
    required this.onAddTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
    required this.onCompleteTask,
    required this.onUncompleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Colors.deepPurple,
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
          const VerticalDivider(color: Colors.grey, width: 1.0),
          Expanded(
            child: CompletedTasksScreen(
              completedTasks: completedTasks,
              onUncompleteTask: onUncompleteTask,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => NewTaskSheet(onAddTask: onAddTask),
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

  const NarrowLayout({
    Key? key,
    required this.tasks,
    required this.completedTasks,
    required this.onAddTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
    required this.onCompleteTask,
    required this.onUncompleteTask,
  }) : super(key: key);

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
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                showCompleted = !showCompleted;
              });
            },
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: showCompleted
            ? CompletedTasksScreen(
                key: ValueKey<bool>(showCompleted),
                completedTasks: widget.completedTasks,
                onUncompleteTask: widget.onUncompleteTask,
              )
            : TaskScreen(
                key: ValueKey<bool>(showCompleted),
                tasks: widget.tasks,
                onAddTask: widget.onAddTask,
                onCompleteTask: widget.onCompleteTask,
                onUpdateTask: widget.onUpdateTask,
                onDeleteTask: widget.onDeleteTask,
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => NewTaskSheet(onAddTask: widget.onAddTask),
          );
        },
      ),
    );
  }
}
