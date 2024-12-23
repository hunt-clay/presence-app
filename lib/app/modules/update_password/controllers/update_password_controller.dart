import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  //TODO: Implement UpdatePasswordController
  TextEditingController currentC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async{
    if (currentC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confirmC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String email = auth.currentUser!.email!;
        await auth.signInWithEmailAndPassword(email: email, password: currentC.text);
        await auth.currentUser!.updatePassword(newC.text);
        Get.back();
        Get.snackbar("Berhasil", "Berhasil update password");
      } on FirebaseAuthException catch (e) {
        if (e.code == "wrong-password") {
          Get.snackbar("Terjadi Kesalahan", "Password yang dimasukkan salah");
        }else{
        Get.snackbar("Terjadi Kesalahan","${e.code.toString().toLowerCase()}");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat update password");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Semua input harus diisi");
    }
  }
}
