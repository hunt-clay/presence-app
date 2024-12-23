import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final credential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );
        if (credential.user != null) {
          isLoading.value = false;
          if (credential.user!.emailVerified == true) {
            if (passC.text == "password") {
              Get.offAllNamed(Routes.PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
                title: "Email belum diverifikasi",
                middleText: "Silahkan verifikasi email",
                actions: [
                  OutlinedButton(
                      onPressed: (() {
                        isLoading.value = false;
                        Get.back();
                      }),
                      child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        //await untuk menunggu user memasukkan atau input email dan password
                        try {
                          await credential.user!.sendEmailVerification();
                          Get.snackbar("Berhasil",
                              "Silahkan cek email untuk verifikasid");
                          Get.back();
                          isLoading.value = false;
                        } catch (e) {
                          isLoading.value = false;
                          Get.snackbar("Terjadi kesalahan",
                              "Tidak dapat mengirim email verifikasi. Silahkan hubungi admin");
                        }
                      },
                      child: Text("Kirim Ulang")),
                ]);
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', "Pegawai tidak ditemukan");
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password Salah');
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak bisa login");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password harus diisi");
    }
  }
}
