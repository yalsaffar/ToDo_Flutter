import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';  
import 'task.dart';
import 'utils.dart';

class CompletedTasksScreen extends StatelessWidget {
  final List<Task> completedTasks;
  final Function(int) onUncompleteTask;

  const CompletedTasksScreen({super.key, 
    required this.completedTasks,
    required this.onUncompleteTask,
  });

  @override
  Widget build(BuildContext context) {
    if (completedTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'No completed tasks!',
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
              'Tasks marked as completed will appear here.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: completedTasks.length,
      itemBuilder: (ctx, index) {
        final task = completedTasks[index];
        return ListTile(
          title: Text(task.title, style: const TextStyle(decoration: TextDecoration.lineThrough)),
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
          trailing: IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () => onUncompleteTask(index),
          ),
        );
      },
    );
  }
}
