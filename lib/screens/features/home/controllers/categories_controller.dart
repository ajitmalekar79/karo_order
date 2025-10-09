import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesController extends GetxController {
  final supabase = Supabase.instance.client;

  var categories = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);

      // Fetch data from Supabase
      final response = await supabase
          .from('categories')
          .select('id, name, image_url')
          .order('name', ascending: true);

      if (response.isNotEmpty) {
        categories.assignAll(List<Map<String, dynamic>>.from(response));
      } else {
        // If no data found, load dummy data
        _loadDummyData();
      }
    } catch (e) {
      print('⚠️ Error fetching categories: $e');
      // On error, use dummy data
      _loadDummyData();
    } finally {
      isLoading(false);
    }
  }

  // Dummy Data Fallback
  void _loadDummyData() {
    final dummyData = [
      {
        'id': 1,
        'name': 'Electronics',
        'image_url': 'https://cdn-icons-png.flaticon.com/512/1040/1040238.png',
      },
      {
        'id': 2,
        'name': 'Fashion',
        'image_url': 'https://cdn-icons-png.flaticon.com/512/892/892458.png',
      },
      {
        'id': 3,
        'name': 'Groceries',
        'image_url': 'https://cdn-icons-png.flaticon.com/512/3076/3076788.png',
      },
      {
        'id': 4,
        'name': 'Home Decor',
        'image_url': 'https://cdn-icons-png.flaticon.com/512/2921/2921822.png',
      },
      {
        'id': 5,
        'name': 'Sports',
        'image_url': 'https://cdn-icons-png.flaticon.com/512/1046/1046790.png',
      },
      {
        'id': 6,
        'name': 'Beauty',
        'image_url': 'https://cdn-icons-png.flaticon.com/512/619/619034.png',
      },
    ];

    categories.assignAll(dummyData);
  }
}
