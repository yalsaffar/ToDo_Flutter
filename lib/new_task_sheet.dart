import 'package:flutter/material.dart';
import 'task.dart';

class NewTaskSheet extends StatefulWidget {
  final Function(Task) onAddTask;

  const NewTaskSheet({super.key, required this.onAddTask});

  @override
  _NewTaskSheetState createState() => _NewTaskSheetState();
}

class _NewTaskSheetState extends State<NewTaskSheet> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime dueDate = DateTime.now().add(const Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
         ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
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
                  selectedTime.minute
                );
              });
            } else {
              setState(() {
                dueDate = selectedDate;
              });
            }
          }
        },
        child: const Text("Select Due Date & Time"),
      ),
            const SizedBox(height: 20)
,
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
            child: const Text("Add Task"),
          ),
        ],
      ),
    );
  }
}
