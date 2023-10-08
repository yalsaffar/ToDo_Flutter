import 'package:flutter/material.dart';
import 'task.dart';
import 'utils.dart';

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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              SizedBox(height: 4),
              Text(
                "Due: ${formatDate(task.dueDate)}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.undo),
            onPressed: () => onUncompleteTask(index),
          ),
        );

      },
    );
  }
}
