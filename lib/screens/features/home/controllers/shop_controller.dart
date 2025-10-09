// controllers/shop_controller.dart
import 'package:get/get.dart';
import '../models/shop_model.dart';

class ShopController extends GetxController {
  var shopList = <ShopModel>[].obs;
  var selectedShop = Rxn<ShopModel>();

  @override
  void onInit() {
    super.onInit();
    fetchUserShops();
  }

  void fetchUserShops() {
    // Example data — replace with API call or Firebase fetch
    shopList.assignAll([
      ShopModel(
        id: '1',
        name: 'Fashion World',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      ShopModel(
        id: '2',
        name: 'Tech Hub',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      ShopModel(
        id: '3',
        name: 'Grocery King',
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ]);
    selectedShop.value = shopList.first;
  }

  void selectShop(ShopModel shop) {
    selectedShop.value = shop;
  }

  void addNewShop() {
    // Navigate to Add Shop screen
  }
}
