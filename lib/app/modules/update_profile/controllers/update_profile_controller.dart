import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileController extends GetxController {
  //TODO: Implement UpdateProfileController
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseFirestore firebase = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void> updateProfile(String uid) async {
    if (nameC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {"name": nameC.text};
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split(".").last;

          await storage.ref("${uid}/profile.${ext}").putFile(file);
          String urlImg =
              await storage.ref("${uid}/profile.${ext}").getDownloadURL();
          data.addAll({
            "profile": urlImg,
          });
        }
        await firebase.collection("pegawai").doc(uid).update(data);
        image = null;
        update();
        Get.back();
        Get.snackbar("Berhasil", "Berhasil update profile");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat mengubah profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.camera);
    update();
  }

  void deleteProfile(String uid) async {
    try {
      isLoading.value = true;
      await firebase
          .collection("pegawai")
          .doc(uid)
          .update({"profile": FieldValue.delete()});
      Get.back();
      Get.snackbar("Berhasil", "Berhasil menghapus profile picture.");
    } catch (e) {
      Get.snackbar(
          "Terjadi Kesalahan", "Tidak dapat menghapus profile picture.");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
