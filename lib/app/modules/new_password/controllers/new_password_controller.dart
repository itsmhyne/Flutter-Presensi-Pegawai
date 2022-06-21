import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mhygetcli/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController passwordC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void newPassword() async {
    if (passwordC.text.isNotEmpty) {
      if (passwordC.text == "password") {
        Get.snackbar("Warning!", "Password anda harus diubah");
      } else {
        try {
          await auth.currentUser!.updatePassword(passwordC.text);
          String email = auth.currentUser!.email!;
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: passwordC.text);
          Get.offAllNamed(Routes.HOME);
          Get.snackbar("Success!", "Anda Berhasil Login");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi Kesalahan!", "Email tidak ditemukan");
          } else {
            Get.snackbar(e.code, e.message!);
          }
        } catch (e) {
          Get.snackbar("Fail!", "Tidak dapat membuat password baru");
        }
      }
    } else if (passwordC.text == "") {
      Get.snackbar("Warning!", "Password anda tidak boleh kosong");
    } else {
      Get.snackbar("Failure", "Tidak dapat mengubah password");
    }
  }
}
