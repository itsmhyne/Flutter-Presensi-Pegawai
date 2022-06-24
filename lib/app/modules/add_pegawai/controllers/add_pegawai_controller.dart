import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void tambahPegawai() async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
          title: "Validasi Admin",
          content: Column(
            children: [
              Text("Masukkan Password untuk validasi"),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordAdminC,
                autocorrect: false,
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                    labelText: "Pasword", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("Cancel")),
            Obx(() => ElevatedButton(
                  onPressed: () async {
                    if (isLoading.isFalse) {
                      await prosesTambahPegawai();
                    }
                  },
                  child: Text(isLoading.isFalse ? "Add Pegawai" : "Loading..."),
                ))
          ]);
    } else {
      print("kosong");
      Get.snackbar("Terjadi Kesalahan", "NIP, Nama, dan Email harus diisi");
    }
  }

  Future<void> prosesTambahPegawai() async {
    if (passwordAdminC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        // cek password
        final userCredential = await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passwordAdminC.text);

        final credential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (credential.user != null) {
          String uid = credential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "created_at": DateTime.now().toIso8601String()
          });

          await credential.user!.sendEmailVerification();
          // logout untuk merefresh snapshot
          await auth.signOut();
          // relogin
          final userCredential = await auth.signInWithEmailAndPassword(
              email: emailAdmin, password: passwordAdminC.text);
          isLoading.value = false;
          Get.back(); //close dialog
          Get.back(); //vback to home
          Get.snackbar("Success!", "Berhasil menambahkan pegawai!");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Password terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Email sudah digunakan");
        } else {
          isLoading.value = false;
          Get.snackbar("Failure!", e.code);
        }
      } catch (e) {
        isLoading.value = false;
        print(e);
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai");
      }
    } else {
      Get.snackbar("Failure!", "Password wajib diisi");
    }
  }
}
