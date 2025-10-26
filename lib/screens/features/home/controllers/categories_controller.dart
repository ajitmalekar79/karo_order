import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/categories_model.dart';
import 'shop_controller.dart';

class CategoriesController extends GetxController {
  final supabase = Supabase.instance.client;

  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchCategories() async {
    try {
      isLoading(true);

      // 🔹 Get vendor_id from selected shop
      final shopController = Get.find<ShopController>();
      final selectedShop = shopController.selectedShop.value;
      print('⚠️ No shop selected. Loading dummy data...');
      if (selectedShop == null || selectedShop.id.isEmpty) {
        print('⚠️ No shop selected. Loading dummy data...');
        _loadDummyData();
        return;
      }

      // 🔹 Fetch categories from Supabase for this vendor
      final response = await supabase
          .from('product_categories')
          .select()
          .eq('vendor_id', selectedShop.userId)
          .eq('is_deleted', false)
          .order('created_at', ascending: true);

      if (response.isNotEmpty) {
        final List<CategoryModel> fetchedCategories = (response as List).map((
          e,
        ) {
          return CategoryModel(
            productCategoryId: e['product_category_id'].toString(),
            vendorId: e['vendor_id'] ?? '',
            categoryName: e['category_name'] ?? 'Unnamed Category',
            categoryDescription: e['category_description'],
            categoryImagePath:
                e['category_image_path'] ??
                'https://via.placeholder.com/150', // fallback image
            isActive: e['is_active'] ?? true,
            isDeleted: e['is_deleted'] ?? false,
            createdAt:
                DateTime.tryParse(e['created_at'] ?? '') ?? DateTime.now(),
            updatedAt:
                DateTime.tryParse(e['updated_at'] ?? '') ?? DateTime.now(),
          );
        }).toList();

        categories.assignAll(fetchedCategories);
      } else {
        // ⚠️ If no categories found, load dummy fallback
        _loadDummyData();
      }
    } catch (e) {
      print('⚠️ Error fetching categories: $e');
      _loadDummyData();
    } finally {
      isLoading(false);
    }
  }

  // 🔹 Dummy Data Fallback
  void _loadDummyData() {
    final dummyData = [
      CategoryModel(
        productCategoryId: '1',
        vendorId: 'dummy_vendor',
        categoryName: 'Electronics',
        categoryDescription: 'Electronic gadgets and devices',
        categoryImagePath:
            'https://cdn-icons-png.flaticon.com/512/1040/1040238.png',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryModel(
        productCategoryId: '2',
        vendorId: 'dummy_vendor',
        categoryName: 'Fashion',
        categoryDescription: 'Clothing and accessories',
        categoryImagePath:
            'https://cdn-icons-png.flaticon.com/512/892/892458.png',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryModel(
        productCategoryId: '3',
        vendorId: 'dummy_vendor',
        categoryName: 'Groceries',
        categoryDescription: 'Daily essentials and food items',
        categoryImagePath:
            'https://cdn-icons-png.flaticon.com/512/3076/3076788.png',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryModel(
        productCategoryId: '4',
        vendorId: 'dummy_vendor',
        categoryName: 'Home Decor',
        categoryDescription: 'Furniture and home accessories',
        categoryImagePath:
            'https://cdn-icons-png.flaticon.com/512/2921/2921822.png',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryModel(
        productCategoryId: '5',
        vendorId: 'dummy_vendor',
        categoryName: 'Sports',
        categoryDescription: 'Sports gear and accessories',
        categoryImagePath:
            'https://cdn-icons-png.flaticon.com/512/1046/1046790.png',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      CategoryModel(
        productCategoryId: '6',
        vendorId: 'dummy_vendor',
        categoryName: 'Beauty',
        categoryDescription: 'Cosmetics and skincare',
        categoryImagePath:
            'https://cdn-icons-png.flaticon.com/512/619/619034.png',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    categories.assignAll(dummyData);
  }
}
