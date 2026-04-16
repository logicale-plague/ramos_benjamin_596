import 'package:flutter/material.dart';
import 'package:modelhandling/controller/user_controller.dart';
import 'package:modelhandling/model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final controller = UserController();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    loadUser();
    // Load users from database
  }

  void loadUser() async {
    final data = await controller.getUsers();
    setState(() {
      users = data;
    });
  }

  void addUser() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      return;
    }
    final user = User(name: nameController.text, email: emailController.text);
    await controller.addUser(user);
    nameController.clear();
    emailController.clear();
    loadUser();
  }

  void deleteUser(int id) async {
    await controller.deleteUser(id);
    loadUser();
  }

  TextField textField({String? label, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  SizedBox spacing({double height = 0, double width = 0}) {
    return SizedBox(height: height, width: width);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            textField(label: 'Name', controller: nameController),
            spacing(height: 10),
            textField(label: 'Email', controller: emailController),
            spacing(height: 10),
            ElevatedButton(
              onPressed: () {
                addUser();
              },
              child: Text('Add User'),
            ),
            spacing(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteUser(user.id!);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
