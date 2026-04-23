import 'package:flutter/material.dart';
import 'package:modelhandling/controller/chat_controller.dart';
import 'package:modelhandling/model/chat_model.dart';

class ChatPage extends StatefulWidget {
  final String username;

  const ChatPage({super.key, required this.username});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = ChatController();
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    // task 1
    // Explanation: Call the necessary controller methods to load existing messages
    //              from the database and start listening for new real-time messages
    //              when this page first opens.
    // Hint: Use controller.loadMessages() to fetch existing messages and
    //       controller.subscribeToMessages() to start the real-time listener.
    super.initState();
    controller.loadMessages();
    controller.subscribeToMessages();
  }

  @override
  void dispose() {
    // task 2
    // Explanation: Dispose all controllers to release resources and avoid memory
    //              leaks when this widget is removed from the widget tree.
    // Hint: Call .dispose() on controller, messageController, and scrollController,
    //       then call super.dispose() at the end.
    controller.dispose();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    // task 3
    // Explanation: Send the typed message via the controller using the current
    //              username, clear the text field, then scroll to the bottom so
    //              the new message is immediately visible.
    // Hint: Call controller.sendMessage(widget.username, messageController.text.trim()),
    //       then messageController.clear(). Use Future.delayed with
    //       scrollController.animateTo(scrollController.position.maxScrollExtent, ...)
    //       to scroll after the list updates.
    // debugPrint('// // // // // text is not empty // // // // //');

    try {
      final message = messageController.text.trim();
      controller.sendMessage(widget.username, message, context);

      // debugPrint('// // // // // uploaded to supabase // // // // //');

      messageController.clear();

      // debugPrint('// // // // // text cleared // // // // //');
      Future.delayed(Duration(milliseconds: 100));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.bounceOut,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (builder) => SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              avatar: const Icon(Icons.person, size: 18),
              label: Text(widget.username),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: controller.messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Start chatting!'),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.username == widget.username;
                    return _buildMessageBubble(msg, isMe);
                  },
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? Colors.indigo : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isMe ? 15 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                msg.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            Text(
              msg.message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(msg.createdAt),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
