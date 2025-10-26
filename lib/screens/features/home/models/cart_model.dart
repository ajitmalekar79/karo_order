class CartModel {
  final String cartId;
  final String userId;
  final String productId;
  final int quantity;
  final double price;
  final double? discountAmount;
  final double? discountedPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  // New product fields
  final String productName;
  final String productDescription;
  final int stock;
  final bool isActive;
  final bool isDeleted;

  CartModel({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.discountAmount,
    this.discountedPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.productName,
    required this.productDescription,
    required this.stock,
    required this.isActive,
    required this.isDeleted,
  });

  factory CartModel.fromJson(
    Map<String, dynamic> json, [
    Map<String, dynamic>? product,
  ]) {
    return CartModel(
      cartId: json['cart_id'] ?? '',
      userId: json['user_id'] ?? '',
      productId: json['product_id'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      discountAmount: json['discount_amount'] != null
          ? (json['discount_amount']).toDouble()
          : null,
      discountedPrice: json['discounted_price'] != null
          ? (json['discounted_price']).toDouble()
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      productName: product?['product_name'] ?? '',
      productDescription: product?['product_description'] ?? '',
      stock: product?['stock'] ?? 0,
      isActive: product?['is_active'] ?? true,
      isDeleted: product?['is_deleted'] ?? false,
    );
  }

  CartModel copyWith({
    String? cartId,
    String? userId,
    String? productId,
    int? quantity,
    double? price,
    double? discountAmount,
    double? discountedPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? productName,
    String? productDescription,
    int? stock,
    bool? isActive,
    bool? isDeleted,
  }) {
    return CartModel(
      cartId: cartId ?? this.cartId,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discountAmount: discountAmount ?? this.discountAmount,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
