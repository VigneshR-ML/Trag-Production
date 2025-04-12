import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_store/data/repositories/products/product_repository.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/helpers/loaders.dart';

class AllProductController extends GetxController{
  static AllProductController get instance => Get.find();

  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async{
    try{
      if(query == null) return [];

      final products = await repository.fetchProductsByQuery(query);
      return products;
    }
    catch(e){
      TLoaders.errorSnackBar(title: "oh Snap!", message: e.toString());
      return [];
    }
  }

  void sortProducts(String sortOption) {
  selectedSortOption.value = sortOption;

  switch (sortOption) {
    case 'Name':
      products.sort((a, b) => a.title.compareTo(b.title));
      break;
    case 'Higher Price':
      products.sort((a, b) => b.price.compareTo(a.price));
      break;
    case 'Lower Price':
      products.sort((a, b) => a.price.compareTo(b.price));
      break;
    case 'Newest':
      products.sort((a, b) => b.date!.compareTo(a.date!));
      break;
    case 'Sale':
      products.sort((a, b) {
        if (b.salePrice > 0 && a.salePrice > 0) {
          return b.salePrice.compareTo(a.salePrice);
        } else if (b.salePrice > 0) {
          return 1;
        } else if (a.salePrice > 0) {
          return -1;
        } else {
          return 0;
        }
      });
      break;
    default:
      products.sort((a, b) => a.title.compareTo(b.title));
      break;
  }
}

void assignProducts(List<ProductModel> products){
  this.products.assignAll(products);
  sortProducts('Name');
}

}