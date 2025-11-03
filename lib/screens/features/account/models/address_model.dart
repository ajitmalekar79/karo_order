class AddressModel {
  final String? userAddressId;
  final String userId;
  final String addressLineOne;
  final String? addressLineTwo;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddressModel({
    this.userAddressId,
    required this.userId,
    required this.addressLineOne,
    this.addressLineTwo,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.phone,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      userAddressId: json['user_address_id'] as String?,
      userId: json['user_id'] ?? '',
      addressLineOne: json['address_line_one'] ?? '',
      addressLineTwo: json['address_line_two'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postal_code'] ?? '',
      phone: json['phone'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isDefault: json['is_default'] ?? false,
      isDeleted: json['is_deleted'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userAddressId != null) 'user_address_id': userAddressId,
      'user_id': userId,
      'address_line_one': addressLineOne,
      'address_line_two': addressLineTwo,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
      'is_deleted': isDeleted,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
