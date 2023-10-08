import 'package:flutter/material.dart';

class InstructionsScreen extends StatefulWidget {
  @override
  _InstructionsScreenState createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instructions'), centerTitle: true),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: <Widget>[
                _buildInstructionPage(
                  title: "TASKS",
                  content: "This is where your tasks are listed.",
                  image: Icons.list,
                ),
                _buildInstructionPage(
                  title: "ADD TASK",
                  content: "You can add a task by pressing this button.",
                  image: Icons.add,
                ),
                _buildInstructionPage(
                  title: "COMPLETE",
                  content: "Completed tasks are marked and separated.",
                  image: Icons.done,
                ),
                // Add more slides as needed
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _currentPage == 0 ? null : () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: Text("Back"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == 2) { // assuming you have 3 slides (0, 1, 2)
                      Navigator.of(context).pushReplacementNamed("/home"); // Route to the HomeScreen
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(_currentPage == 2 ? "Start" : "Next"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInstructionPage({required String title, required String content, required IconData image}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(image, size: 100.0, color: Colors.indigo),
          SizedBox(height: 20.0),
          Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(content, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
