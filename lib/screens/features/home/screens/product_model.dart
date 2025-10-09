class ProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  /// Factory constructor to create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image_url': imageUrl, 'price': price};
  }
}
