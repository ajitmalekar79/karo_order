// pages/add_shop_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'scan_view.dart';

class AddShopPage extends StatelessWidget {
  AddShopPage({super.key});

  final TextEditingController _shopCodeController = TextEditingController();

  // Gradient Colors
  final LinearGradient greenGradient = const LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  void _addShop() {
    // Logic to add a shop manually
    Get.snackbar(
      "Add Shop",
      "Shop added successfully!",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _scanQr() {
    // QR scan logic
    Get.to(ScanView());
  }

  void _enterCode(BuildContext context) {
    final code = _shopCodeController.text.trim();
    if (code.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a shop code",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Logic to add shop by code
    _shopCodeController.clear();

    // Show animated success popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(ctx).pop();
        });
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: greenGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade200.withOpacity(0.6),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.network(
                  'https://assets8.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                  width: 220,
                  height: 220,
                  repeat: false,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Shop Added Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Shop",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: greenGradient.colors.first,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Gradient Header with Shop Icon
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                gradient: greenGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.storefront, size: 90, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    "Add Your Shop",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Quickly add shops to your account",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Add Shop Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 58),
              child: InkWell(
                onTap: _addShop,
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.white24,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: greenGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade200.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_business, color: Colors.white, size: 28),
                      SizedBox(width: 8),
                      Text(
                        "Add Shop",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Scan QR Option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),

              child: Container(
                padding: EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: _scanQr,
                  leading: Container(
                    decoration: BoxDecoration(
                      gradient: greenGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  title: const Text(
                    "Scan QR to Add Shop",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Enter Shop Code Option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: greenGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.code,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _shopCodeController,
                          decoration: const InputDecoration(
                            hintText: "Enter Shop Code",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenGradient.colors.first,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _enterCode(context),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: const Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
