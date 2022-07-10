import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mhygetcli/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Berhasil", "Email reset password berhasil dikirim");
        Get.offAllNamed(Routes.LOGIN);
      } catch (e) {
        Get.snackbar("Error", "Tidak dapat mengirim email reset password!");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Peringatan!", "Email tidak boleh kosong");
    }
  }
}
