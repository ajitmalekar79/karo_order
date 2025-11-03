import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/address_model.dart';

class AddressController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool isLoading = false.obs;

  final supabase = Supabase.instance.client;
  final String table = 'user_addresses';

  /// Fetch all user addresses
  Future<void> fetchAddresses(String userId) async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from(table)
          .select()
          .eq('user_id', userId)
          .eq('is_deleted', false)
          .order('is_default', ascending: false)
          .order('created_at', ascending: false);

      addresses.value = response.map((e) => AddressModel.fromJson(e)).toList();
    } catch (e, st) {
      print('fetchAddresses error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new address
  Future<AddressModel?> addAddress(AddressModel address) async {
    try {
      if (address.isDefault) {
        await _clearDefault(address.userId);
      }

      final response = await supabase
          .from(table)
          .insert(address.toJson())
          .select()
          .single();

      final inserted = AddressModel.fromJson(response);
      addresses.insert(0, inserted);
      return inserted;
    } catch (e) {
      print('addAddress error: $e');
      rethrow;
    }
  }

  /// Update address
  Future<AddressModel?> updateAddress(
    String userAddressId,
    AddressModel model,
  ) async {
    try {
      if (model.isDefault) {
        await _clearDefault(model.userId);
      }

      final response = await supabase
          .from(table)
          .update(model.toJson())
          .eq('user_address_id', userAddressId)
          .select()
          .single();

      final updated = AddressModel.fromJson(response);
      final idx = addresses.indexWhere(
        (a) => a.userAddressId == updated.userAddressId,
      );
      if (idx != -1) {
        addresses[idx] = updated;
        addresses.refresh();
      }
      return updated;
    } catch (e) {
      print('updateAddress error: $e');
      rethrow;
    }
  }

  /// Soft delete
  Future<void> deleteAddress(String userAddressId) async {
    try {
      await supabase
          .from(table)
          .update({'is_deleted': true})
          .eq('user_address_id', userAddressId);

      addresses.removeWhere((a) => a.userAddressId == userAddressId);
    } catch (e) {
      print('deleteAddress error: $e');
    }
  }

  /// Set as default
  Future<void> setDefaultAddress(AddressModel address) async {
    try {
      await _clearDefault(address.userId);

      await supabase
          .from(table)
          .update({'is_default': true})
          .eq('user_address_id', address.userAddressId!);

      await fetchAddresses(address.userId);
    } catch (e) {
      print('setDefaultAddress error: $e');
    }
  }

  /// Helper: unset all previous defaults
  Future<void> _clearDefault(String userId) async {
    try {
      await supabase
          .from(table)
          .update({'is_default': false})
          .eq('user_id', userId);
    } catch (e) {
      print('_clearDefault error: $e');
    }
  }
}
