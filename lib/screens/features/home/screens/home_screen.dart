import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karo_order/utils/color_constants.dart';
import '../../../../utils/constants.dart';
import '../controllers/categories_controller.dart';
import '../controllers/products_controller.dart';
import '../controllers/shop_controller.dart';
import 'drawer.dart';
import 'dart:ui';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopController = Get.find<ShopController>();
    final categoryController = Get.put(CategoriesController());
    final productController = Get.put(ProductController());

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // 👈 Change this to your desired color
        ),
        backgroundColor: Color(0xFF2E7D32),
        title: Text(
          AppConstants.appName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],

        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         Color.fromARGB(255, 217, 234, 218),
        //         Color.fromARGB(255, 218, 237, 219),
        //         Color.fromARGB(255, 218, 232, 230),
        //       ],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //   ),
        // ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait(
            [
                  shopController.fetchUserShops(),
                  categoryController.fetchCategories(),
                ]
                as Iterable<Future>,
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏪 Selected Shop Header
              Obx(() {
                final selectedShop = shopController.selectedShop.value;

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2E7D32),
                        Color.fromARGB(255, 174, 213, 189),
                        Color.fromARGB(255, 216, 230, 221),
                        Colors.white,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Decorative floating shapes
                            Positioned(
                              top: -40,
                              right: -30,
                              child: Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    134,
                                    25,
                                    123,
                                  ).withValues(alpha: 0.07),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -30,
                              left: -20,
                              child: Transform.rotate(
                                angle: 0.2,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      201,
                                      167,
                                      167,
                                    ).withValues(alpha: 0.05),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: -20,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    66,
                                    17,
                                    49,
                                  ).withValues(alpha: 0.10),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            // Glassmorphic Card Content
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 12,
                                  sigmaY: 12,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Shop Header
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 32,
                                            backgroundColor: Colors.white
                                                .withValues(alpha: 0.2),
                                            child: Icon(
                                              Icons.storefront_rounded,
                                              color: const Color.fromARGB(
                                                255,
                                                57,
                                                29,
                                                41,
                                              ),
                                              size: 34,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  selectedShop?.name ??
                                                      'No Shop Selected',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10),

                                      // Shop Details

                                      // Accent curved line
                                      Container(
                                        height: 4,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color.fromARGB(
                                                255,
                                                107,
                                                44,
                                                65,
                                              ).withValues(alpha: 0.6),
                                              Colors.transparent,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      AnimatedSearchBar(
                        onTap: () {
                          // Get.to(
                          //   () => const SearchScreen(),
                          //   transition: Transition.rightToLeftWithFade,
                          //   duration: const Duration(milliseconds: 400),
                          // );
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Categories',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      Obx(() {
                        if (categoryController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final categories = categoryController.categories;

                        if (categories.isEmpty) {
                          return const Center(
                            child: Text(
                              'No categories available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 100,

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return _buildCategoryCard(
                                category['name'] ?? '',
                                category['image_url'],
                                AppColors.themeColor,
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),

              // 🧭 Categories Section
              Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // 🧾 Recent Orders
                    Text(
                      'Products',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Obx(() {
                      if (productController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final products = productController.products;

                      if (products.isEmpty) {
                        return Center(child: Text('No products available'));
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      product.imageUrl.isNotEmpty
                                          ? product.imageUrl
                                          : '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            // Show placeholder if image fails
                                            return Container(
                                              width: double.infinity,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                                size: 48,
                                              ),
                                            );
                                          },
                                      loadingBuilder:
                                          (context, child, progress) {
                                            if (progress == null) return child;
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    product.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '₹${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 8),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String? imageUrl, Color color) {
    return Container(
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category details
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageUrl != null)
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(imageUrl),
                  backgroundColor: Colors.white,
                )
              else
                Icon(Icons.category, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedSearchBar extends StatefulWidget {
  final VoidCallback? onTap; // 🔹 New onTap callback

  const AnimatedSearchBar({super.key, this.onTap});

  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  final List<String> hints = [
    "Search for products...",
    "Find your favorite shop...",
    "Explore new arrivals...",
    "Get the best deals!",
  ];
  int _currentHintIndex = 0;

  @override
  void initState() {
    super.initState();
    _startHintAnimation();
  }

  void _startHintAnimation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentHintIndex = (_currentHintIndex + 1) % hints.length;
        });
        _startHintAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // 🔹 Use the callback passed from parent
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  hints[_currentHintIndex],
                  key: ValueKey<String>(hints[_currentHintIndex]),
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
            ),
            const Icon(Icons.search, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
