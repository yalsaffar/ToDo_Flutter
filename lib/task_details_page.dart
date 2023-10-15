import 'package:flutter/material.dart';
import 'task.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdateTask;
  final Function() onDeleteTask;
  final Function() onCompleteTask;

  const TaskDetailsPage({
    Key? key,
    required this.task,
    required this.onUpdateTask,
    required this.onDeleteTask,
    required this.onCompleteTask,
  }) : super(key: key);

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  // Carlo: Here you could initialise directly. E.g.: late TextEditingController _titleController = TextEditingController();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  // Carlo: Same with dueDate. E.g.: DateTime dueDate = DateTime.now();
  DateTime dueDate;

// Carlo: Initialising before would let you delete this line of code.
  _TaskDetailsPageState() : dueDate = DateTime.now();  // default initialization

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    dueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Carlo: You could extract date & time picker into a separate function.
  // Carlo: You could use a reusable function for button styling.
  // Carlo: Could use a FutureBuilder to show a CircularProgressIndicator while the task is being updated.
  // Carlo: Could also wrap text fields in a form widget.
  // Carlo: Could add a confirmation dialog for the different actions.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              widget.onDeleteTask();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
                      child: Text('Change Date & Time'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Complete Task'),
                      onPressed: () {
                        widget.onCompleteTask();
                        Navigator.pop(context);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
