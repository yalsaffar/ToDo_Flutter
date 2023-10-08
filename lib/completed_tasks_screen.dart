import 'package:flutter/material.dart';
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
