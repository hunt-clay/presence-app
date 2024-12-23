import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  //TODO: Implement AddPegawaiController
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;
        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passAdminC.text);

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "password");

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          //add data to firestore
          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "role":"pegawai",
            "job":jobC,
            "createdAt": DateTime.now().toIso8601String(),

          });

          //send verification email to user
          await pegawaiCredential.user!.sendEmailVerification();

          //logout dari pegawai
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: emailAdmin, password: passAdminC.text);
          Get.back(); //tutup dialog
          Get.back(); //back to home
          Get.snackbar("Berhasil", "Berhasil menambahkan pegawai");
        }
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar(
              'Terjadi Kesalahan', "Password yang digunakan terlaalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi Kesalahan', 'Pegawai sudah terdaftar');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password yang dimasukkan salah');
        } else {
          Get.snackbar('Terjadi Kesalahan', e.toString());
        }
      } catch (e) {
        isLoadingAddPegawai.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambah pegawai");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Password belum diisi.");
    }
  }

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        nipC.text.isNotEmpty&&jobC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
          title: "Validasi Admin",
          content: Column(
            children: [
              Text("Masukkan password untuk validasi"),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                    label: Text("Password"), border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  isLoading.value = false;
                  Get.back();
                },
                child: Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (isLoadingAddPegawai.isFalse) {
                  await prosesAddPegawai();
                }
                isLoading.value = false;
              },
              child: isLoadingAddPegawai.isFalse
                  ? Text("Add Pegawai")
                  : Text("Loading..."),
            )
          ]);
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP, Nama, Job, dan Email harus diisi.");
    }
  }
}
