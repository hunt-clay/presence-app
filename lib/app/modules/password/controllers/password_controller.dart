import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class PasswordController extends GetxController {
  //TODO: Implement PasswordController
  TextEditingController userPasswordC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> newPassword() async {
    if (userPasswordC.text.isNotEmpty) {
      if (userPasswordC.text != "password") {
        try {
          String email = auth.currentUser!.email!;
          await auth.currentUser!.updatePassword(userPasswordC.text);
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: userPasswordC.text);
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar('Terjadi Kesalahan', "Password terlalu lemah");
          } 
        }
        catch (e){
            Get.snackbar('Terjadi Kesalahan', 'Password harus diubah ');
          }
        }
      } else {
        Get.snackbar("Terjadi kesalahan", "Harus diisi");
      }
    } 
  }

