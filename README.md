# TodoList

A modern, native macOS/iOS application for managing tasks with priority groups. Built with SwiftUI and Core Data.

## Features

- Create, edit, and delete tasks
- Organize tasks into priority groups:
  - Today (Red)
  - This Week (Blue)
  - When There Is Time (Green)
- Persistent storage using Core Data
- Native macOS/iOS interface with split view layout
- Visual priority indicators with color coding
- Completed tasks automatically move to the bottom
- Task counts show active (non-completed) items
- Smooth animations and transitions

## Requirements

- macOS 12.0+ or iOS 15.0+
- Xcode 14.0+
- Swift 5.5+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/karingit/todo-list.git
```

2. Open the project in Xcode:
```bash
cd todo-list
open TodoList.xcodeproj
```

3. Build and run the project (⌘R)

## Usage

- Click the "+" button to add a new task
- Select a priority group when creating a task
- Click the checkbox to mark a task as complete
- Use the menu (⋯) to:
  - Change a task's priority group
  - Delete a task
- Tasks are automatically sorted with completed items at the bottom
- The sidebar shows active task counts for each priority group

## Architecture

- Built with SwiftUI for the user interface
- Core Data for persistent storage
- MVVM architecture with SwiftUI bindings
- Native macOS/iOS split view navigation

## License

This project is available under the MIT license. See the LICENSE file for more info.
