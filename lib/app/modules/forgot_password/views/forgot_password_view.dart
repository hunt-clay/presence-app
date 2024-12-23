import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FORGOT PASSWORD'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            TextField(
              controller: controller.emailC,
              autocorrect: false,
              decoration: InputDecoration(
                  label: Text("Email"), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => ElevatedButton(
                  onPressed: () async{
                    if (controller.isLoading.isFalse) {
                      await controller.sendEmail();
                    }
                  },
                  child: controller.isLoading.isFalse
                      ? Text("Send Reset Password")
                      : Text("Loading...")),
            )
          ],
        ));
  }
}
