import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';  
import 'task.dart';
import 'task_details_page.dart';
import 'utils.dart';

class TaskScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onAddTask;
  final Function(int) onCompleteTask;
  final Function(int, Task) onUpdateTask;
  final Function(int) onDeleteTask;

  const TaskScreen({super.key, 
    required this.tasks,
    required this.onAddTask,
    required this.onCompleteTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'It\'s empty here!',
                  textStyle: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  speed: Duration(milliseconds: 100),
                ),
              ],
              repeatForever: true,
            ),
            SizedBox(height: 20.0),
            
            Text(
              'Add some tasks to get started.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Carlo
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              const SizedBox(height: 4),
              Text(
                "Due: ${formatDate(task.dueDate)}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsPage(
                        task: task,
                        onUpdateTask: (updatedTask) {
                          onUpdateTask(index, updatedTask);
                        },
                        onDeleteTask: () {
                          onDeleteTask(index); 
                        },
                        onCompleteTask: () {
                          onCompleteTask(index);
                        },
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => onCompleteTask(index),
              ),
            ],
          ),
        );
      },
    );
  }
}
