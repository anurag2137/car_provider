import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChatScreen(),
  ));
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Scaffold key added

  List<dynamic> messages = []; // Store File objects instead of strings

  TextEditingController _textEditingController = TextEditingController();

  bool _isSendingImage = false;
  bool _showSentImageMessage = false;
  bool _lastMessageWasSentByUser = false; // Flag to track the last message sender

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isSendingImage = true;
        messages.add(File(pickedFile.path)); // Store File object
      });

      // Show message for 2 seconds
      setState(() {
        _showSentImageMessage = true;
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _showSentImageMessage = false;
      });

      setState(() {
        _isSendingImage = false;
      });
    }
  }

  bool get _isNewDummyMessage {
    // Check if the first message is a dummy message
    return messages.isNotEmpty && messages[0] is String && messages[0].toLowerCase() == 'dummy message';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Scaffold key added
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/backii.jpeg', // Replace with your image file name
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    if (index == 0 && _isNewDummyMessage) { // Adjusted condition
                      return _buildSentDummyMessage(); // Changed method name
                    } else {
                      final message = messages[index];
                      final isMe = _lastMessageWasSentByUser;
                      _lastMessageWasSentByUser = !isMe && message is String;
                      return MessageBubble(
                        message: message,
                        isMe: isMe, // Use the flag to determine message alignment
                        showSeenIcon: index == 0 && !_isSendingImage,
                        onTapImage: (File image) {
                          _showSavedImagePreview(image);
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        _getImageFromGallery();
                      },
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        String message = _textEditingController.text;
                        if (message.isNotEmpty) {
                          setState(() {
                            messages.insert(0, message);
                            _textEditingController.clear();
                          });

                          // Show popup for sent text message
                          // _showSentTextMessagePopup(message);

                          // Simulate receiving a dummy message after 2 seconds
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              messages.insert(0, getDummyMessage(message)); // Use getDummyMessage to get the corresponding dummy message
                            });

                            // Show notification when dummy message is received
                            _showDummyNotification();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isSendingImage)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_showSentImageMessage)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Image Sent',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Function to build a sent dummy message
  Widget _buildSentDummyMessage() {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dummy Message',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Function to show a pop-up for sent text message
  // void _showSentTextMessagePopup(String message) {
  //   _scaffoldKey.currentState!.showSnackBar(
  //     SnackBar(
  //       content: Text('Sent: $message'),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }

  // Function to show a dummy notification
  void _showDummyNotification() {
    // Implementation to show notification
    // This can vary depending on your notification requirements
  }

  // Function to show preview of the saved image
  void _showSavedImagePreview(File image) {
    // Implementation to show image preview
    // This can be a dialog, modal bottom sheet, or any other widget to display the image
  }

  // Function to get dummy message based on user input
  String getDummyMessage(String userMessage) {
    // Map user inputs to corresponding dummy messages
    if (userMessage.toLowerCase().contains('hello') || userMessage.toLowerCase().contains('hi')) {
      return 'Hello';
    } else if (userMessage.toLowerCase().contains('how are you')) {
      return 'I am fine';
    } else if (userMessage.toLowerCase().contains('image')) {
      return 'Nice!';
    } else if (userMessage.toLowerCase().contains('good morning')) {
      return 'Good morning!';
    } else if (userMessage.toLowerCase().contains('good afternoon')) {
      return 'Good afternoon!';
    } else if (userMessage.toLowerCase().contains('good evening')) {
      return 'Good evening!';
    } else if (userMessage.toLowerCase().contains('good night')) {
      return 'Good night!';
    } else if (userMessage.toLowerCase().contains('thank you')) {
      return 'You\'re welcome!';
    } else if (userMessage.toLowerCase().contains('howdy')) {
      return 'Howdy!';
    } else if (userMessage.toLowerCase().contains('hey')) {
      return 'Hey there!';
    } else if (userMessage.toLowerCase().contains('kaise ho')) {
      return 'Main theek hoon';
    } else if (userMessage.toLowerCase().contains('aur tum')) {
      return 'Mai bhi theek hoon';
    } else if (userMessage.toLowerCase().contains('kya kar rahe ho')) {
      return 'Kuch nahi, bas yahi';
    } else if (userMessage.toLowerCase().contains('tumhara naam kya hai')) {
      return 'Mera naam anurag hai';
    } else if (userMessage.toLowerCase().contains('aap kahan se ho')) {
      return 'Main bharati se hoon';
    } else if (userMessage.toLowerCase().contains('acha')) {
      return 'aur batao';
    } else if (userMessage.toLowerCase().contains('mai photo bheju kya ')) {
      return 'haa sure y not';
    } else if (userMessage.toLowerCase().contains('batao kaisa hai ')) {
      return 'badhiya ';
    } else {
      return 'I don\'t understand';
    }
  }
}

class MessageBubble extends StatelessWidget {
  final dynamic message;
  final bool isMe;
  final bool showSeenIcon;
  final Function(File image)? onTapImage;

  MessageBubble({
    required this.message,
    required this.isMe,
    required this.showSeenIcon,
    this.onTapImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isMe) ...[
            CircleAvatar(
              radius: 20.0,
              backgroundImage: AssetImage('assets/images/boy.jpeg'),
            ),
            SizedBox(width: 10.0),
          ],
          Flexible(
            child: GestureDetector(
              onTap: () {
                if (message is File && onTapImage != null) {
                  onTapImage!(message);
                }
              },
              child: Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: isMe ? Colors.lightBlueAccent : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: isMe ? Radius.circular(30.0) : Radius.circular(0.0),
                    bottomRight: isMe ? Radius.circular(0.0) : Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: message is File
                    ? Image.file(
                  message,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                )
                    : Text(
                  '$message',
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          if (showSeenIcon && isMe)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(Icons.done_all, color: Colors.blue),
            ),
        ],
      ),
    );
  }
}
