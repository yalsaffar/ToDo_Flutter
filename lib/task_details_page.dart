import 'package:flutter/material.dart';
import 'task.dart';


class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdateTask;
  final Function() onDeleteTask;
  final Function() onCompleteTask;

  TaskDetailsPage({
    required this.task,
    required this.onUpdateTask,
    required this.onDeleteTask,
    required this.onCompleteTask,
  });

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime dueDate;

  _TaskDetailsPageState() : dueDate = DateTime.now();  // default initialization

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    dueDate = widget.task.dueDate;  // Initialize the dueDate with the task's dueDate
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.onDeleteTask();
              Navigator.pop(context); // After deletion, immediately pop the page.
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(dueDate),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      dueDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                }
              },
              child: Text("Change Due Date & Time"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Complete Task'),
              onPressed: () {
                widget.onCompleteTask();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Update Task Details'),
              onPressed: () {
                Task updatedTask = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  dueDate: dueDate,
                  isCompleted: widget.task.isCompleted,
                );
                widget.onUpdateTask(updatedTask);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

