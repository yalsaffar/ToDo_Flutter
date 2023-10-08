# My ToDo App

A modern and clean ToDo application built with Flutter. It provides a seamless experience to users, allowing them to manage tasks efficiently with intuitive animations and features.

## File Structure

### 1. `main.dart`
The main entry point for the application. It sets up the main theme and routing for the app.

- **`MyApp`**: The root widget for the app. 
- **`SplashScreen`**: The splash screen shown on app startup, featuring a beautiful animation and a warm welcome.
- **`HomeScreen`**: The main screen of the app which displays tasks and allows users to interact with them.
- **`WideLayout`**: A layout for wider screens which splits tasks and completed tasks side by side.
- **`NarrowLayout`**: A layout for narrow screens which toggles between tasks and completed tasks.

### 2. `task.dart`
Defines the `Task` class used for task management throughout the app.

### 3. `task_screen.dart`
This is where all the pending tasks are listed. Users can interact with tasks (complete, edit, delete) directly from this screen.

### 4. `completed_tasks_screen.dart`
Displays the completed tasks. Users can revert a task's status to incomplete from here.

### 5. `new_task_sheet.dart`
A bottom sheet that appears when users want to add a new task to their list.

### 6. `instructions_screen.dart`
A series of slides introducing users to the functionalities of the app. Useful for first-time users.

### 7. `task_details_page.dart`
A detailed view of each task. Provides options to update, delete, or mark a task as completed.

### 8. `utils.dart`
Contains utility functions used throughout the application, such as formatting dates.

## Features

- **Animations**: The app features smooth animations, providing a good user experience.
- **Adaptive Layout**: Adjusts its interface based on the width of the device screen.
- **Easy Task Management**: Add, complete, edit, or delete tasks with ease.

## Getting Started

1. Clone the repository.
2. Navigate to the project directory and run `flutter pub get` to install dependencies.
3. Launch the app using `flutter run`.


