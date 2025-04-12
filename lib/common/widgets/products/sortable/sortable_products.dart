import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:t_store/features/shop/controllers/all_product_controller.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/constraints/sizes.dart';

class TSortableProducts extends StatelessWidget {
  const TSortableProducts({
    super.key, required this.products,
  });

  final List<ProductModel> products;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductController());
    controller.assignProducts(products);
    return Column(
      children: [
        ///dropdown
        DropdownButtonFormField(
          value: controller.selectedSortOption.value,
          decoration:
          const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          onChanged: (value) {
            controller.sortProducts(value!);
          },
          items: [
            'Name',
            'Higher price',
            'Lower price',
            'Sale',
            'New',
            'Popularity'
          ]
              .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option)))
              .toList(),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        ///products
        Obx(() => TGridLayout(itemCount: controller.products.length, itemBuilder: (_, index) => TProductCardVertical(product: controller.products[index]))),
      ],
    );
  }
}