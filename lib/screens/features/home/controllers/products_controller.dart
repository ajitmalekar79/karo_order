import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/product_model.dart';
import '../controllers/shop_controller.dart'; // import your ShopController

class ProductController extends GetxController {
  final supabase = Supabase.instance.client;

  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      // 🔹 Get selected shop vendor ID
      final shopController = Get.find<ShopController>();
      final selectedShop = shopController.selectedShop.value;

      if (selectedShop == null) {
        Get.snackbar('Error', 'No shop selected.');
        isLoading.value = false;
        return;
      }

      final vendorId = selectedShop.userId;

      // 🔹 Fetch ALL columns from Supabase for this vendor
      final response = await supabase
          .from('products')
          .select() // fetch all columns
          .eq('vendor_id', vendorId)
          .order('created_at', ascending: true);

      if (response != null && response is List) {
        products.assignAll(
          response.map((item) => ProductModel.fromJson(item)).toList(),
        );
      } else {
        products.clear();
        Get.snackbar('Info', 'No products found for this vendor.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products: $e');
      products.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
