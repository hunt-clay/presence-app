import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('UPDATE PASSWORD'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextField(
              controller: controller.currentC,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                  label: Text("Current Password"),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.newC,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                  label: Text("New Password"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.confirmC,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                  label: Text("Confirm Password"),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.updatePassword();
                    }
                  },
                  child: Text(controller.isLoading.isFalse
                      ? "Ubah Password"
                      : "Loading...")),
            )
          ],
        ));
  }
}
