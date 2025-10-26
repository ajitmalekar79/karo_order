import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // adjust path if needed

class CustomerVendorController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Returns a Map with: { "success": bool, "message": "..." }
  Future<Map<String, dynamic>> addShopByCode(
    String code,
    String customerId,
  ) async {
    try {
      // Step 1: Find vendor by code
      final vendor = await supabase
          .from('vendors')
          .select('vendor_id')
          .eq('vendor_code', code)
          .maybeSingle();

      if (vendor == null) {
        return {"success": false, "message": "No shop found with this code"};
      }

      final vendorId = vendor['vendor_id'];

      // Step 2: Check if already linked
      final existing = await supabase
          .from('customer_vendors')
          .select()
          .eq('customer_id', customerId)
          .eq('vendor_id', vendorId)
          .maybeSingle();

      if (existing != null) {
        return {
          "success": false,
          "message": "This shop is already linked to your account",
        };
      }

      // Step 3: Insert relation
      await supabase.from('customer_vendors').insert({
        'customer_id': customerId,
        'vendor_id': vendorId,
        'is_selected': false,
        'is_deleted': false,
        'created_at': DateTime.now().toIso8601String(),
      });

      return {"success": true, "message": "Shop added successfully!"};
    } catch (e) {
      return {"success": false, "message": "Something went wrong: $e"};
    }
  }
}
