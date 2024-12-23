import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ADD PEGAWAI'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextField(
              autocorrect: false,
              controller: controller.nipC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("NIP")),
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
              height: 20,
            ),
            TextField(
              autocorrect: false,
              controller: controller.jobC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("Job")),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              controller: controller.emailC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("Email")),
            ),
            SizedBox(
              height: 30,
            ),
            Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.addPegawai();
                  }
                },
                child: controller.isLoadingAddPegawai.isFalse
                    ? Text("Add Pegawai")
                    : Text("Loading...")))
          ],
        ));
  }
}
