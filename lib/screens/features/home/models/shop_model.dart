class ShopModel {
  final String id;
  final String userId;
  final String name;
  final String imageUrl;
  final String code;
  bool isSelected;

  ShopModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageUrl,
    this.code = '',
    required this.isSelected,
  });
}
