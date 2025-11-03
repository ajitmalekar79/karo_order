// lib/pages/shipping_addresses_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/address_controller.dart';
import '../models/address_model.dart';
import 'add_edit_address.dart';
import 'widgets/address_card.dart';

class ShippingAddressesPage extends StatelessWidget {
  // you can pass currentUserId (from auth) to page
  final String currentUserId;
  final AddressController controller = Get.put(AddressController());

  ShippingAddressesPage({Key? key, required this.currentUserId})
    : super(key: key) {
    controller.fetchAddresses(currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shipping Addresses')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // open add page, then refresh list after
          await Get.to(() => AddEditAddressPage(userId: currentUserId));
          await controller.fetchAddresses(currentUserId);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No addresses yet.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    await Get.to(
                      () => AddEditAddressPage(userId: currentUserId),
                    );
                    await controller.fetchAddresses(currentUserId);
                  },
                  child: const Text('Add Address'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAddresses(currentUserId),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: controller.addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final AddressModel address = controller.addresses[idx];
              return AddressCard(
                address: address,
                onEdit: () async {
                  await Get.to(
                    () => AddEditAddressPage(
                      userId: currentUserId,
                      address: address,
                    ),
                  );
                  await controller.fetchAddresses(currentUserId);
                },
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete address?'),
                      content: const Text(
                        'Are you sure you want to delete this address?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    try {
                      await controller.deleteAddress(address.userAddressId!);
                      Get.snackbar('Deleted', 'Address deleted');
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to delete address');
                    }
                  }
                },
                onSetDefault: () async {
                  try {
                    await controller.setDefaultAddress(address);
                    Get.snackbar('Updated', 'Default address set');
                  } catch (e) {
                    Get.snackbar('Error', 'Failed to set default');
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}
