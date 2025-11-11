# 📚 Project 1: Personal Profile App\*

- Description: Simple personal portfolio app.
- Learned: Basic layout (Column, Card), Responsive UI, Dark Mode.

# 📚 Project 2: Todo App (Local State)

This is a simple to-do list application built with Flutter. The primary goal of this project is to practice managing local state using `StatefulWidget` and `setState()`.

## ✨ Features

- **Add** new tasks via an `AlertDialog`.
- **Complete** tasks by tapping a checkbox, which toggles a `lineThrough` text style.
- **Delete** tasks from the list.

## 🚀 Core Concepts Demonstrated

- **`StatefulWidget`:** Used to hold and manage the list of tasks.
- **`setState()`:** Called whenever a task is added, toggled, or deleted to rebuild the UI with the new state.
- **`ListView.builder()`:** Efficiently displays the scrollable list of tasks.

# 📚 Project 3: News Reader App

This is a real-time news application built with Flutter. It fetches live data from the [NewsAPI.org](https://newsapi.org/) REST API and displays the top headlines.

## ✨ Features

- Fetches live "Top Headlines" from the NewsAPI.
- Displays a **loading indicator** (`CircularProgressIndicator`) while waiting for data.
- Handles **errors** gracefully (e.g., network issues or invalid API key).
- Displays articles in a `ListView` using custom `Card` widgets.
- Tapping an article opens the full story in the device's browser using `url_launcher`.
- Securely manages the API key using a `.env` file.

## 🚀 Core Concepts Demonstrated

- **`http` package:** Used to make `GET` requests to a REST API.
- **`async / await`:** For handling asynchronous network calls.
- **JSON Parsing:** Converting the JSON response (`dart:convert`) into Dart model classes (`Article.fromJson`).
- **`FutureBuilder`:** The core widget used to handle the different states of an API call (loading, error, and success/data).
- **`url_launcher`:** For opening external links.
- **`flutter_dotenv`:** For securely storing and accessing the API key.

# 📚 Project 4: Chat UI Clone

This project is a visual clone of a modern chat interface, similar to WhatsApp or Messenger. The focus is purely on UI/UX design, layout, and scrolling, not on backend functionality.

## ✨ Features

- **Dynamic Message Bubbles:** The UI distinguishes between "sent" messages (aligned right, blue background) and "received" messages (aligned left, dark grey background).
- **Complex Layout:** Uses a `Column` to separate the scrolling chat history (`ListView`) from the fixed message input bar at the bottom.
- **Custom Styling:** `Container` widgets are styled with `BorderRadius` to create the classic "bubble" shape.
- **Mock Input Bar:** A functional-looking (but non-operative) input bar with a `TextField` and "Send" icon.

## 🚀 Core Concepts Demonstrated

- **`ListView.builder`:** For creating the scrollable list of messages.
- **`Row` & `Column`:** Used extensively for structuring the screen and aligning message bubbles.
- **`Container`:** Heavily used for padding, margins, color, and `BoxDecoration` (to create the bubble shape).
- **`Expanded`:** To make the `ListView` fill all available space above the input bar.
- **Layout Logic:** Using ternary operators (`isMe ? ... : ...`) inside the `build` method to dynamically change the alignment and styling of widgets.
