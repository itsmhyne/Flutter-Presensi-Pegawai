// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LoginView')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
              controller: controller.emailC,
              decoration: InputDecoration(
                  labelText: "Email", border: OutlineInputBorder())),
          SizedBox(
            height: 20,
          ),
          TextField(
              controller: controller.passwordC,
              obscureText: true,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                  labelText: "Password", border: OutlineInputBorder())),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                controller.login();
              },
              child: Text("LOGIN")),
          TextButton(onPressed: () {}, child: Text("Lupa Password?"))
        ],
      ),
    );
  }
}
