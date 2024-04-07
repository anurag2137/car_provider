
import 'package:flutter/material.dart';

class MessengerApp extends StatefulWidget {
  @override
  _MessengerAppState createState() => _MessengerAppState();
}

class _MessengerAppState extends State<MessengerApp> {
  List<Message> messages = [];
  TextEditingController _controller = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'INBOX!',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Expanded Search bar
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // You can implement search functionality here
              },
            ),
          ),
          Divider(),
          // Expanded Message list
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageItem(
                  message: message,
                  onUnsend: () {
                    setState(() {
                      messages.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          // Message Input Field
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    final messageText = _controller.text.trim();
                    if (messageText.isNotEmpty) {
                      // Sending message functionality
                      _controller.clear();
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String sender;
  final String content;
  final DateTime timestamp;

  Message({
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}

class MessageItem extends StatelessWidget {
  final Message message;
  final VoidCallback onUnsend;

  MessageItem({
    required this.message,
    required this.onUnsend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Text(message.sender[0]), // Display first letter of sender
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.sender,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Text(message.content),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: onUnsend,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MessengerApp(),
  ));
}
