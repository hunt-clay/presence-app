import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  //TODO: Implement ForgotPasswordController
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value =true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Berhasil", "Silakan cek email untuk reset password");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan",
            "Tidak dapat mengirim reset password ke email");
      }finally{
        isLoading.value = false;
      }
    }
  }
}
