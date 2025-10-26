import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../controllers/auth_controller.dart';
import '../controllers/customer_vendor_controller.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  bool isLoading = true;
  bool isScanProcessing = false;
  String scanData = '';
  String isSucess = '';
  late String _currentTime;
  late String _currentDate;
  final customerVendorController = Get.put(CustomerVendorController());
  final authController = Get.find<AuthController>();
  late final user = authController.user;

  final LinearGradient greenGradient = const LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  void initState() {
    super.initState();
    _checkPermissionAndInitializeCamera();
  }

  Future<void> _checkPermissionAndInitializeCamera() async {
    final status = await Permission.camera.status;

    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission required')),
        );
        return;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(
        DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)),
      );
    });
  }

  void getValidUser() async {
    try {
      if (scanData.isNotEmpty) {
        String jsonString = scanData;
      }
    } catch (e) {
      setState(() {
        isSucess = 'Invalid Data';
      });
    }
  }

  void showCreditedPointsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AnimatedDialog(),
    );
  }

  void _enterCode(BuildContext context, code) async {
    if (code.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a shop code",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final customerId = user?.userId ?? ''; // Replace accordingly

    // ✅ Call controller method and wait for response
    final result = await customerVendorController.addShopByCode(
      code,
      customerId,
    );

    if (result['success']) {
      // ✅ Show success dialog
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
      Get.back();
    } else {
      // ❌ Show backend error message
      Get.snackbar(
        "Error",
        result['message'] ?? "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Scanner'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                MobileScanner(
                  onDetect: (capture) {
                    if (!isScanProcessing) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        isScanProcessing = true;
                        scanData = barcodes.first.rawValue ?? '';
                        _updateTime();
                        _enterCode(context, scanData);

                        Future.delayed(const Duration(seconds: 3), () {
                          isScanProcessing = false;
                        });
                      }
                    }
                  },
                ),
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 5),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: width,
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Scan QR'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class AnimatedDialog extends StatefulWidget {
  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with TickerProviderStateMixin {
  // Animation controller for scaling the dialog
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // Define the scaling animation
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    // Start the animation
    _controller.forward();
  }

  // Disposing of the animation controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The dialog content
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.star, size: 50, color: Colors.yellow),
                  const SizedBox(height: 20),
                  const Text(
                    'Points credited successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Action on "Okay" button click
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Okay', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
