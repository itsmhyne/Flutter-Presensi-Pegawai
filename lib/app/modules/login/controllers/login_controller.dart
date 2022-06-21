import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mhygetcli/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    print("onpressed");
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        final credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passwordC.text);
        // check apakah email isvalid
        if (credential.user != null) {
          if (credential.user!.emailVerified == true) {
            if (passwordC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
              Get.snackbar("Success!", "Anda Berhasil Login");
            }
          } else {
            Get.defaultDialog(
                title: "Peringatan!",
                middleText:
                    "Kamu belum verifikasi email ini. Lakukan verifikasi email anda terlebih dahulu!",
                actions: [
                  OutlinedButton(
                      onPressed: () => Get.back(), child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await credential.user!.sendEmailVerification();
                          Get.back();
                          Get.snackbar("Info!",
                              "Email verifikasi berhasil dikirim ulang ke alamat email anda!");
                        } catch (e) {
                          Get.snackbar("Failure!",
                              "Tidak dapat mengirim email verifikasi.\nHubungi Admin!");
                        }
                      },
                      child: Text("Kirim Ulang"))
                ]);
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar("Failure!", "Email tidak ditemukan");
          emailC.text = "";
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Failure!", "Password anda salah.");
          passwordC.text = "";
        }
        print(e.code);
      } catch (e) {
        Get.snackbar("Failure!", "Tidak dapat login.");
        emailC.text = "";
        passwordC.text = "";
      }
    } else {
      Get.snackbar("Failure!", "Email dan Password tidak boleh kosong");
    }
  }

  void forgot() async {
    Get.snackbar("Info!", "Fitur ini masih dalam tahap pengerjaan!");
  }
}
