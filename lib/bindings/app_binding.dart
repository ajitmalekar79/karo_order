import 'package:get/get.dart';
import 'package:karo_order/screens/features/home/controllers/shop_controller.dart';

import '../screens/features/home/controllers/cart_controller.dart';
import '../screens/features/home/controllers/categories_controller.dart'
    show CategoriesController;
import '../screens/features/home/controllers/customer_vendor_controller.dart';
import '../screens/features/home/controllers/products_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ShopController>(ShopController(), permanent: true);
    Get.put<CategoriesController>(CategoriesController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);
    Get.put<CustomerVendorController>(
      CustomerVendorController(),
      permanent: true,
    );
    Get.put<CartController>(CartController(), permanent: true);
  }
}
