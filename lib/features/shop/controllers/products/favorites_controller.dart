import 'dart:convert';
import 'package:get/get.dart';
import 'package:t_store/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store/data/repositories/products/product_repository.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/helpers/loaders.dart';
import 'package:t_store/utils/local_storage/storange_utility.dart';

class FavouriteController extends GetxController {
  static FavouriteController get instance => Get.find();

  final favourites = <String, bool>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final authRepo = Get.find<AuthenticationRepository>();
    if (authRepo.authUser != null) {
      print('User is authenticated, loading favorites');
      initFavourites();
    } else {
      print('No authenticated user found');
      isLoading.value = false;
    }
  }

  Future<void> initFavourites() async {
    try {
      print('Initializing favorites from storage');
      final json = TLocalStorage.instance().readData('favourites');
      print('Raw favorites data from storage: $json');

      if (json != null) {
        final storedFavourites = jsonDecode(json) as Map<String, dynamic>;
        favourites.assignAll(
            storedFavourites.map((key, value) => MapEntry(key, value as bool)));
        print('Parsed favorites: ${favourites.toString()}');
      } else {
        print('No favorites found in storage, initializing empty map');
        // Initialize with an empty map to ensure it's not null
        favourites.value = {};
      }
    } catch (e) {
      print('Error loading favorites: $e');
      // Initialize with an empty map in case of error
      favourites.value = {};
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavourite(String productId) {
    final result = favourites[productId] ?? false;
    print('Checking if product $productId is favorite: $result');
    return result;
  }

  void toggleFavouriteProduct(String productId) {
    print('TOGGLE: Starting toggle for product: $productId');
    print('TOGGLE: Current favorites: ${favourites.toString()}');

    // Create a new map to trigger a proper update
    final updatedFavorites = Map<String, bool>.from(favourites);

    if (updatedFavorites.containsKey(productId)) {
      print('TOGGLE: Removing product from favorites');
      updatedFavorites.remove(productId);
      TLoaders.customToast(
          message: "Product has been removed from the Wishlist.");
    } else {
      print('TOGGLE: Adding product to favorites');
      updatedFavorites[productId] = true;
      TLoaders.customToast(message: "Product has been added to the Wishlist.");
    }

    // Update the observable and notify listeners
    favourites.value = updatedFavorites;
    print('TOGGLE: Updated favorites: ${favourites.toString()}');

    // Save to storage
    saveFavouritesToStorage();
  }

  void saveFavouritesToStorage() {
    try {
      final encodedFavourites = json.encode(favourites);
      print('STORAGE: Saving favorites: $encodedFavourites');
      TLocalStorage.instance().saveData('favourites', encodedFavourites);
      print('STORAGE: Favorites saved successfully');
    } catch (e) {
      print('STORAGE ERROR: Failed to save favorites: $e');
    }
  }

  Future<List<ProductModel>> favouriteProducts() async {
    if (favourites.isEmpty) {
      print('No favorites found, returning empty list');
      return [];
    }

    final ids = favourites.keys.toList();
    print('Fetching favorite products with IDs: $ids');

    if (ids.isEmpty) {
      return [];
    }

    try {
      return await ProductRepository.instance.getFavouriteProducts(ids);
    } catch (e) {
      print('Error fetching favorite products: $e');
      return [];
    }
  }
}
