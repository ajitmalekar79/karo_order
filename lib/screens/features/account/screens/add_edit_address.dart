import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/address_controller.dart';
import '../models/address_model.dart';

class AddEditAddressPage extends StatefulWidget {
  final String userId;
  final AddressModel? address;

  const AddEditAddressPage({Key? key, required this.userId, this.address})
    : super(key: key);

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final AddressController _controller = Get.find();

  late TextEditingController _nameCtr;
  late TextEditingController _addressLineOneCtr;
  late TextEditingController _addressLineTwoCtr;
  late TextEditingController _cityCtr;
  late TextEditingController _stateCtr;
  late TextEditingController _countryCtr;
  late TextEditingController _postalCtr;
  late TextEditingController _phoneCtr;
  late TextEditingController _latitudeCtr;
  late TextEditingController _longitudeCtr;

  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final a = widget.address;

    _nameCtr = TextEditingController(
      text: '',
    ); // optional field (you can link to user later)
    _addressLineOneCtr = TextEditingController(text: a?.addressLineOne ?? '');
    _addressLineTwoCtr = TextEditingController(text: a?.addressLineTwo ?? '');
    _cityCtr = TextEditingController(text: a?.city ?? '');
    _stateCtr = TextEditingController(text: a?.state ?? '');
    _countryCtr = TextEditingController(text: a?.country ?? '');
    _postalCtr = TextEditingController(text: a?.postalCode ?? '');
    _phoneCtr = TextEditingController(text: a?.phone ?? '');
    _latitudeCtr = TextEditingController(text: a?.latitude?.toString() ?? '');
    _longitudeCtr = TextEditingController(text: a?.longitude?.toString() ?? '');
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _addressLineOneCtr.dispose();
    _addressLineTwoCtr.dispose();
    _cityCtr.dispose();
    _stateCtr.dispose();
    _countryCtr.dispose();
    _postalCtr.dispose();
    _phoneCtr.dispose();
    _latitudeCtr.dispose();
    _longitudeCtr.dispose();
    super.dispose();
  }

  String? phoneValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final cleaned = v.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\+?\d{7,15}$').hasMatch(cleaned)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final double? latitude = _latitudeCtr.text.trim().isNotEmpty
        ? double.tryParse(_latitudeCtr.text.trim())
        : null;
    final double? longitude = _longitudeCtr.text.trim().isNotEmpty
        ? double.tryParse(_longitudeCtr.text.trim())
        : null;

    final model = AddressModel(
      userAddressId: widget.address?.userAddressId ?? '',
      userId: widget.userId,
      addressLineOne: _addressLineOneCtr.text.trim(),
      addressLineTwo: _addressLineTwoCtr.text.trim(),
      city: _cityCtr.text.trim(),
      state: _stateCtr.text.trim(),
      country: _countryCtr.text.trim(),
      postalCode: _postalCtr.text.trim(),
      phone: _phoneCtr.text.trim().isEmpty ? null : _phoneCtr.text.trim(),
      latitude: latitude,
      longitude: longitude,
      isDefault: _isDefault,
      isDeleted: false,
      createdAt: widget.address?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      if (widget.address == null) {
        await _controller.addAddress(model);
        Get.back();
        Get.snackbar('Success', 'Address added successfully');
      } else {
        await _controller.updateAddress(widget.address!.userAddressId!!, model);
        Get.back();
        Get.snackbar('Success', 'Address updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save address');
      debugPrint('Error saving address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Address' : 'Add Address')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Address line 1
              TextFormField(
                controller: _addressLineOneCtr,
                decoration: const InputDecoration(labelText: 'Address Line 1'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 12),

              // Address line 2
              TextFormField(
                controller: _addressLineTwoCtr,
                decoration: const InputDecoration(labelText: 'Address Line 2'),
              ),
              const SizedBox(height: 12),

              // City & State
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityCtr,
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateCtr,
                      decoration: const InputDecoration(labelText: 'State'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Country & Postal
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _countryCtr,
                      decoration: const InputDecoration(labelText: 'Country'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _postalCtr,
                      decoration: const InputDecoration(
                        labelText: 'Postal Code',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        if (v.trim().length < 3) return 'Invalid postal code';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Phone
              TextFormField(
                controller: _phoneCtr,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: phoneValidator,
              ),
              const SizedBox(height: 12),

              // Latitude / Longitude
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeCtr,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeCtr,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Default toggle
              SwitchListTile(
                title: const Text('Set as default address'),
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEdit ? 'Save Changes' : 'Add Address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
