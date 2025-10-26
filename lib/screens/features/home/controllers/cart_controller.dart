import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../controllers/auth_controller.dart' show AuthController;
import '../models/cart_model.dart';

class CartController extends GetxController {
  final supabase = Supabase.instance.client;
  var cartItems = <CartModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      final auth = Get.find<AuthController>();
      final user = auth.user;

      if (user == null) return;

      final cartResponse = await supabase
          .from('cart')
          .select()
          .eq('user_id', user.userId);

      List<CartModel> tempCart = [];

      for (var c in cartResponse) {
        final productId = c['product_id'];

        // Fetch product details
        final productResponse = await supabase
            .from('products')
            .select()
            .eq('product_id', productId)
            .single();

        if (productResponse != null) {
          tempCart.add(CartModel.fromJson(c, productResponse));
        }
      }

      cartItems.value = tempCart;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(String productId, double price) async {
    try {
      final auth = Get.find<AuthController>();
      final user = auth.user;

      if (user == null) {
        Get.snackbar('Error', 'Please log in first');
        return;
      }

      final existingItem = cartItems.firstWhereOrNull(
        (item) => item.productId == productId,
      );

      if (existingItem != null) {
        await updateQuantity(productId, existingItem.quantity + 1);
      } else {
        // Fetch product details from "product" table
        final productResponse = await supabase
            .from('products')
            .select()
            .eq('product_id', productId)
            .single();

        if (productResponse == null) {
          Get.snackbar('Error', 'Product not found');
          return;
        }

        // Insert into cart table
        final response = await supabase.from('cart').insert({
          'user_id': user.userId,
          'product_id': productId,
          'quantity': 1,
          'price': price,
          'discount_amount': productResponse['discount_amount'] ?? 0,
          'discounted_price': productResponse['discounted_price'] ?? price,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }).select();

        if (response.isNotEmpty) {
          // Populate CartModel with product details
          final newCartItem = CartModel.fromJson(
            response.first,
            productResponse,
          );
          cartItems.add(newCartItem);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to cart: $e');
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      final auth = Get.find<AuthController>();
      final user = auth.user;

      if (user == null) return;

      if (quantity <= 0) {
        await removeFromCart(productId);
        return;
      }

      await supabase
          .from('cart')
          .update({
            'quantity': quantity,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', user.userId)
          .eq('product_id', productId);

      final index = cartItems.indexWhere((c) => c.productId == productId);
      if (index != -1) {
        cartItems[index] = cartItems[index].copyWith(quantity: quantity);
        cartItems.refresh();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity: $e');
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final auth = Get.find<AuthController>();
      final user = auth.user;

      if (user == null) return;

      await supabase
          .from('cart')
          .delete()
          .eq('user_id', user.userId)
          .eq('product_id', productId);

      cartItems.removeWhere((c) => c.productId == productId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove product: $e');
    }
  }

  int getQuantity(String productId) {
    return cartItems
            .firstWhereOrNull((e) => e.productId == productId)
            ?.quantity ??
        0;
  }
}
