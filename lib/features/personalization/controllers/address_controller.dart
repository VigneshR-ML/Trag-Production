import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:t_store/data/repositories/address/address_repository.dart';
import 'package:t_store/features/personalization/models/address_model.dart';
import 'package:t_store/utils/constraints/image_strings.dart';
import 'package:t_store/utils/helpers/loaders.dart';
import 'package:t_store/utils/helpers/network_manager.dart';
import 'package:t_store/utils/popups/full_screen_loader.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final AddressRepository addressRepository = Get.put(AddressRepository());
  RxBool refreshData = true.obs;

  /// Fetch all user-specific addresses
  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere(
        (element) => element.selectedAddress,
        orElse: () => AddressModel.empty(),
      );
      return addresses;
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Address not found",
        message: e.toString(),
      );
      return [];
    }
  }

Future<void> selectAddress(AddressModel newSelectedAddress) async {
  try {
    // First, deselect ALL addresses (to ensure no duplicate selections)
    await addressRepository.deselectAllAddresses();
    
    // Then select only the new address
    await addressRepository.updateSelectedField(newSelectedAddress.id, true);
    
    // Update local state
    newSelectedAddress.selectedAddress = true;
    selectedAddress.value = newSelectedAddress;
    
  } catch (e) {
    TLoaders.errorSnackBar(
      title: 'Error in address selection', 
      message: e.toString()
    );
  }
}

  Future addNewAddresses() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Wait a Sec!! Storing Address.....', TImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!addressFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final address = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        postalCode: postalCode.text.trim(),
        country: country.text.trim(),
        selectedAddress: true,
      );

      final id = await addressRepository.addAddress(address);

      address.id = id;
      selectedAddress.value = address;

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: 'Done!', message: "Your address has been saved successfully.");

      refreshData.toggle();

      resetFormFields();

      Navigator.of(Get.context!).pop();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Address Not Found", message: e.toString());
    }
  }

  void resetFormFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState?.reset();
  }
}
