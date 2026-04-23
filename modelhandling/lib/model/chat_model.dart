class Message {
  final int? id;
  final String username;
  final String message;
  final DateTime? createdAt;

  Message({
    this.id,
    required this.username,
    required this.message,
    this.createdAt,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    // task 4
    // Explanation: Parse a raw Map (from the database) into a Message object by
    //              reading each key and assigning it to the correct field. The
    //              created_at value is a string that must be converted to DateTime.
    // Hint: Return Message(id: map['id'], username: map['username'],
    //       message: map['message'], createdAt: map['created_at'] != null
    //       ? DateTime.parse(map['created_at']) : null).
    return Message(
      id: map['id'],
      username: map['username'],
      message: map['message'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
    // throw UnimplementedError('task 4: implement fromMap');
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'message': message};
  }
}
