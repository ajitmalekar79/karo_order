import 'package:get/get.dart';
import 'package:karo_order/screens/features/home/controllers/products_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../controllers/auth_controller.dart';
import '../models/shop_model.dart';
import 'categories_controller.dart';

class ShopController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var shopList = <ShopModel>[].obs;
  var selectedShop = Rxn<ShopModel>();
  var isLoading = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchUserShops();
  // }

  /// ✅ Fetch shops linked with the logged-in customer
  Future<void> fetchUserShops() async {
    try {
      isLoading.value = true;

      final authController = Get.find<AuthController>();
      final user = authController.user;

      if (user == null || user.userId == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final response = await supabase
          .from('customer_vendors')
          .select(
            'vendor_id, is_selected,vendors(vendor_name, vendor_code,user_id)',
          )
          .eq('customer_id', user.userId)
          .eq('is_deleted', false);

      if (response.isEmpty) {
        shopList.clear();
        selectedShop.value = null;
        return;
      }

      final List<ShopModel> fetchedShops = response.map<ShopModel>((item) {
        final vendor = item['vendors'];
        return ShopModel(
          id: item['vendor_id'] ?? '',
          userId: vendor['user_id'] ?? '',
          name: vendor?['vendor_name'] ?? 'Unknown Shop',
          imageUrl: 'https://via.placeholder.com/150',
          code: vendor?['vendor_code'] ?? '',
          isSelected: item['is_selected'] ?? false,
        );
      }).toList();

      shopList.assignAll(fetchedShops);

      // ✅ Step 1: Check if any shop has isSelected = true
      final selected = shopList.firstWhereOrNull(
        (shop) => shop.isSelected == true,
      );

      if (selected != null) {
        // Found already selected shop
        selectShop(selected);
      } else if (shopList.isNotEmpty) {
        // ✅ Step 2: If no shop selected, pick first and update Supabase
        final firstShop = shopList.first;
        // selectedShop.value = firstShop;
        selectShop(firstShop);
        firstShop.isSelected = true;

        await supabase
            .from('customer_vendors')
            .update({'is_selected': true})
            .eq('vendor_id', firstShop.id)
            .eq('customer_id', user.userId);
      } else {
        selectedShop.value = null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch shops: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Select a specific shop from list
  void selectShop(ShopModel shop) async {
    try {
      final authController = Get.find<AuthController>();
      final user = authController.user;

      if (user == null || user.userId == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      // 🔹 Step 1: Update local selected shop
      selectedShop.value = shop;

      // 🔹 Step 2: Reset all shops in Supabase to false
      await supabase
          .from('customer_vendors')
          .update({'is_selected': false})
          .eq('customer_id', user.userId);

      // 🔹 Step 3: Mark selected shop as true
      await supabase
          .from('customer_vendors')
          .update({'is_selected': true})
          .eq('customer_id', user.userId)
          .eq('vendor_id', shop.id);

      // 🔹 Step 4: Update local list for UI refresh
      for (var s in shopList) {
        s.isSelected = (s.id == shop.id);
      }
      shopList.refresh();

      // 🔹 Step 5: Fetch updated categories for this shop
      final categoriesController = Get.find<CategoriesController>();
      await categoriesController.fetchCategories();

      final productController = Get.find<ProductController>();
      await productController.fetchProducts();

      // Get.snackbar('Success', '${shop.name} selected successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update shop selection: $e');
    }
  }
}
