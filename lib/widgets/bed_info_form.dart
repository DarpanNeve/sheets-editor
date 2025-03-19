import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/home_page.dart';
import 'custom_text_field.dart';

class BedInfoForm extends StatelessWidget {
  const BedInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomePage.controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bed Information",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          controller: controller.widthController,
          labelText: "Transplanting bed width (m)",
          hintText: "Enter width in meters",
          icon: Icons.straighten,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          controller: controller.lengthController,
          labelText: "Transplanting bed length (m)",
          hintText: "Enter length in meters",
          icon: Icons.straighten,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          controller: controller.distanceController,
          labelText: "Plant to plant distance (mm)",
          hintText: "Enter distance in millimeters",
          icon: Icons.space_bar,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
