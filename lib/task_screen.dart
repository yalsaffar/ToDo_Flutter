import 'package:flutter/material.dart';
import 'task.dart';
import 'task_details_page.dart';
import 'utils.dart';

class TaskScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onAddTask;
  final Function(int) onCompleteTask;
  final Function(int, Task) onUpdateTask;
  final Function(int) onDeleteTask;

  TaskScreen({
    required this.tasks,
    required this.onAddTask,
    required this.onCompleteTask,
    required this.onUpdateTask,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 4),
              Text(
                "Due: ${formatDate(task.dueDate)}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
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
                icon: Icon(Icons.check),
                onPressed: () => onCompleteTask(index),
              ),
            ],
          ),
        );

      },
    );
  }
}
