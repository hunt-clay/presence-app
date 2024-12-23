import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments!;
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user["nip"];
    controller.nameC.text = user["name"];
    controller.emailC.text = user["email"];
    return Scaffold(
        appBar: AppBar(
          title: Text('UpdateProfileView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextField(
              readOnly: true,
              autocorrect: false,
              controller: controller.nipC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("NIP")),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              readOnly: true,
              autocorrect: false,
              controller: controller.emailC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("Email")),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              controller: controller.nameC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("Name")),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<UpdateProfileController>(
                  builder: (controller) {
                    if (controller.image != null) {
                      if (controller.isLoading.isTrue) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Image.file(
                                File(controller.image!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      if (user["profile"] != null) {
                        return Column(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  user["profile"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  controller.deleteProfile(user["uid"]);
                                },
                                child: Text("delete"))
                          ],
                        );
                      } else {
                        return Text("no iamge");
                      }
                    }
                  },
                ),
                TextButton(
                    onPressed: () {
                      controller.pickImage();
                    },
                    child: Text("Choose data"))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.updateProfile(user["uid"]);
                  }
                },
                child: controller.isLoading.isFalse
                    ? Text("Ubah Profile")
                    : Text("Loading..."))),
          ],
        ));
  }
}
