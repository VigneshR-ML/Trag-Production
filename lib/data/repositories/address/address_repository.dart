import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_store/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store/features/personalization/models/address_model.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<AddressModel>> fetchUserAddresses() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;

      if (userId == null || userId.isEmpty) {
        throw 'Unable to find user information. Try again in a few minutes.';
      }

      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .get();

      return result.docs
          .map((documentSnapshot) =>
              AddressModel.fromDocumentSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching address information. Try again later.';
    }
  }

  Future<void> updateSelectedField(String addressId, bool selected) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .doc(addressId)
          .update({'SelectedAddress': selected});
    } catch (e) {
      throw 'Unable to update your address selection. Try again later';
    }
  }

  Future<String> addAddress(AddressModel address) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final currentAddress = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .add(address.toJson());
      return currentAddress.id;
    } catch (e) {
      throw 'Something went wrong while saving address information. Try again later';
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .doc(addressId)
          .delete();
    } catch (e) {
      throw 'Unable to delete address. Please try again later.';
    }
  }

  Future<void> deselectAllAddresses() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;

      if (userId == null || userId.isEmpty) {
        throw 'Unable to find user information. Try again in a few minutes.';
      }
      final userAddressesRef =
          _db.collection('Users').doc(userId).collection('Addresses');

      final selectedAddressesQuery = await userAddressesRef
          .where('SelectedAddress', isEqualTo: true)
          .get();

      final batch = _db.batch();

      for (final doc in selectedAddressesQuery.docs) {
        batch.update(doc.reference, {'SelectedAddress': false});
      }
      await batch.commit();
    } catch (e) {
      
      throw 'Unable to update address selection. Please try again later.';
    }
  }
}
