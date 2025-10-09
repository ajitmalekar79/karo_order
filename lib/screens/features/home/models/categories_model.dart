class Category {
  final String id;
  final String name;
  final String icon; // store icon name or url
  final String color; // hex color code or string

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String? ?? 'restaurant',
      color: map['color'] as String? ?? '#FF9800',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'icon': icon, 'color': color};
  }
}
