import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../services/sheet_service.dart';

class HomeController extends GetxController {
  // Text editing controllers for input fields.
  final widthController = TextEditingController();
  final lengthController = TextEditingController();
  final distanceController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isUpdateSuccessful = false.obs;

  final SheetService _sheetService = SheetService();

  // Reactive variables to hold the six sheet cells.
  final RxString cellB14 = ''.obs;
  final RxString cellK14 = ''.obs;
  final RxString cellN14 = ''.obs;
  final RxString cellO14 = ''.obs;
  final RxString cellP14 = ''.obs;
  final RxString cellQ14 = ''.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Start periodic fetch every 5 seconds.
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchSheetParameters();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    widthController.dispose();
    lengthController.dispose();
    distanceController.dispose();
    super.onClose();
  }

  /// Fetches the latest sheet data and updates the reactive variables.
  Future<void> fetchSheetParameters() async {
    try {
      final data = await _sheetService.getSheetData();
      cellB14.value = data['B14']?.toString() ?? '';
      cellK14.value = data['K14']?.toString() ?? '';
      cellN14.value = data['N14']?.toString() ?? '';
      cellO14.value = data['O14']?.toString() ?? '';
      cellP14.value = data['P14']?.toString() ?? '';
      cellQ14.value = data['Q14']?.toString() ?? '';
    } catch (e) {
      print("Error fetching sheet data: $e");
      errorMessage.value = "Error fetching sheet data: $e";
    }
  }

  /// Updates the sheet with input values.
  Future<void> updateSheet() async {
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

  void clearInputs() {
    widthController.clear();
    lengthController.clear();
    distanceController.clear();
  }
}
