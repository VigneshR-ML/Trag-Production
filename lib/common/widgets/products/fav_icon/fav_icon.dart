import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/icons/t_circular_icon.dart';
import 'package:t_store/features/shop/controllers/products/favorites_controller.dart';
import 'package:t_store/utils/constraints/colors.dart';

class TFavouriteIcon extends StatelessWidget {
  const TFavouriteIcon({super.key, required this.productId});
  final String productId;
  @override 
  Widget build(BuildContext context) {
    final controller = Get.put(FavouriteController());
    return Obx(() => TCircularIcon(
        icon: controller.isFavourite(productId) ? Iconsax.heart5 : Iconsax.heart,
        color: controller.isFavourite(productId) ? TColors.error : null,
        onPressed: () => controller.toggleFavouriteProduct(productId)));
  }
}