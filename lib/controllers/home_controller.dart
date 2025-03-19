import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/sheet_service.dart';

class HomeController extends GetxController {
  final widthController = TextEditingController();
  final lengthController = TextEditingController();
  final distanceController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isUpdateSuccessful = false.obs;

  final SheetService _sheetService = SheetService();

  @override
  void onClose() {
    widthController.dispose();
    lengthController.dispose();
    distanceController.dispose();
    super.onClose();
  }

  void clearInputs() {
    widthController.clear();
    lengthController.clear();
    distanceController.clear();
  }

  Future<void> updateSheet() async {
    // Parse input values.
    double? bedWidth = double.tryParse(widthController.text);
    double? bedLength = double.tryParse(lengthController.text);
    double? plantDistance = double.tryParse(distanceController.text);

    if (bedWidth == null || bedLength == null || plantDistance == null) {
      Get.snackbar(
        'Input Error',
        'Please enter valid numeric values',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      isUpdateSuccessful.value = false;

      // Call the service to update the sheet.
      final response = await _sheetService.updateSheet(
        bedWidth: bedWidth,
        bedLength: bedLength,
        plantDistance: plantDistance,
      );

      if (response.statusCode == 200) {
        isUpdateSuccessful.value = true;
        Get.snackbar(
          'Success',
          'Sheet updated successfully!',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        clearInputs();
      } else {
        throw Exception('Failed to update sheet: ${response.body}');
      }
    } catch (e) {
      errorMessage.value = 'Failed to update sheet: $e';
      Get.snackbar(
        'Error',
        'Failed to update sheet: $e',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
