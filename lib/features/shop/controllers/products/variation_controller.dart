import 'package:get/get.dart';
import 'package:t_store/features/shop/controllers/products/images_controller.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/features/shop/models/product_variation_model.dart';

/// VariationController handles selecting the correct product variation based on attributes.
class VariationController extends GetxController {
  // Use Get.find to retrieve the current instance.
  static VariationController get instance => Get.find();

  /// Observable map holding the selected attribute key/value pairs.
  RxMap selectedAttributes = {}.obs;

  /// Observable string for the variation stock status.
  RxString variationStockStatus = ''.obs;
  Rx<ProductVariationModel> selectedVariation =
      ProductVariationModel.empty().obs;

  void onAttributeSelected(
      ProductModel product, attributeName, attributeValue) {
    final selectedAttributes =
        Map<String, dynamic>.from(this.selectedAttributes);
    selectedAttributes[attributeName] = attributeValue;
    this.selectedAttributes[attributeName] = attributeValue;

    final selectedVariation = product.productVariations!.firstWhere(
        (variation) => _isSameAttributeValues(
            variation.attributeValues, selectedAttributes),
        orElse: () => ProductVariationModel.empty());

    if (selectedVariation.image.isNotEmpty) {
      ImagesController.instance.selectedProductImage.value =
          selectedVariation.image;
    }

    this.selectedVariation.value = selectedVariation;

    getProductVariationStockStatus();
  }

  bool _isSameAttributeValues(
  Map<String, dynamic> variationAttributes,
  Map<String, dynamic> selectedAttributes,
) {
  for (final key in selectedAttributes.keys) {
    if (!variationAttributes.containsKey(key) ||
        variationAttributes[key] != selectedAttributes[key]) {
      return false;
    }
  }
  return true;
}


  /// Check the product variation stock status.
  void getProductVariationStockStatus() {
    variationStockStatus.value =
        selectedVariation.value.stock > 0 ? 'In Stock' : 'Out of Stock';
  }

  /// Reset selected attributes when switching products.
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }
}
