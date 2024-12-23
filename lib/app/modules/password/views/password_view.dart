import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/password_controller.dart';

class PasswordView extends GetView<PasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PasswordView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
        TextField(
          obscureText: true,
          controller: controller.userPasswordC,
          autocorrect: false,
          decoration: InputDecoration(
            label: Text("New Password"),
            border: OutlineInputBorder()
          ),
        ),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: (){
          controller.newPassword();
        }, child: Text("Continue")),
      ],)
    );
  }
}
