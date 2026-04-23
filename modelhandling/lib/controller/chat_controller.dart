import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modelhandling/model/chat_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatController {
  final supabase = Supabase.instance.client;

  // Stream controller for real-time updates
  final _messagesController = StreamController<List<Message>>.broadcast();
  Stream<List<Message>> get messagesStream => _messagesController.stream;

  List<Message> _messages = [];
  RealtimeChannel? _channel;

  // Load initial messages
  Future<void> loadMessages() async {
    final data = await supabase
        .from('messages')
        .select()
        .order('created_at', ascending: true);

    _messages = data.map((item) => Message.fromMap(item)).toList();
    _messagesController.add(_messages);
  }

  // Subscribe to real-time updates
  void subscribeToMessages() {
    _channel = supabase
        .channel('public:messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            // New message received!
            final newMessage = Message.fromMap(payload.newRecord);
            _messages.add(newMessage);
            _messagesController.add(_messages);
          },
        )
        .subscribe();
  }

  // Send a message
  Future<void> sendMessage(
    String username,
    String message,
    BuildContext context,
  ) async {
    // task 5
    // Explanation: Create a Message object from the provided username and message,
    //              then insert it into the Supabase 'messages' table.
    // Hint: Instantiate Message(username: username, message: message), then call
    //       await supabase.from('messages').insert(newMessage.toMap()).
    try {
      final newMessage = Message(username: username, message: message);
      await supabase.from('messages').insert(newMessage.toMap());
    } catch (e) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (builder) =>
            SnackBar(content: Text('Failed to insert to Supabase')),
      );
    }
  }

  // Clean up
  void dispose() {
    _channel?.unsubscribe();
    _messagesController.close();
  }
}
