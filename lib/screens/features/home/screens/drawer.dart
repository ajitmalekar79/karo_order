// widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karo_order/utils/color_constants.dart';
import '../controllers/shop_controller.dart';
import 'add_shop_screen.dart';

class AppDrawer extends StatelessWidget {
  final ShopController controller = Get.find<ShopController>();

  final LinearGradient greenGradient = const LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(() {
        final selected = controller.selectedShop.value;
        final shops = controller.shopList;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🏪 Header: Selected Shop
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(gradient: greenGradient),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile (Shop) Image
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      selected?.imageUrl ?? 'https://via.placeholder.com/100',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Shop Name
                  Text(
                    selected?.name ?? "No Shop Selected",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Subtitle / Info
                  Text(
                    shops.isEmpty
                        ? "No shops available. Add a new shop."
                        : "Tap on a shop to switch",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // ➕ Add Shop Button
            Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.add_business, color: Colors.white),
                title: const Text(
                  "Add New Shop",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Get.to(AddShopPage());
                },
              ),
            ),

            const Divider(),

            // 🏬 All Shops List or Empty Message
            Expanded(
              child: shops.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "You don't have any shops yet.\nTap 'Add New Shop' to create one.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        final shop = shops[index];
                        final isSelected = shop.id == selected?.id;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(shop.imageUrl),
                          ),
                          title: Text(shop.name),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            controller.selectShop(shop);
                            Navigator.pop(context); // close drawer
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
