import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final DateTime? dateTime;
  bool selectedAddress;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.dateTime,
    this.selectedAddress = true,
  });

  // Example formatted getter (if TFornatter exists, else replace with real logic)
  String get formattedPhoneNo =>
      phoneNumber; // Replace with actual formatter if needed

  // Factory method to create an empty model
  static AddressModel empty() => AddressModel(
        id: '',
        name: '',
        phoneNumber: '',
        street: '',
        city: '',
        state: '',
        postalCode: '',
        country: '',
      );

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Street': street,
      'City': city,
      'State': state,
      'PostalCode': postalCode,
      'Country': country,
      'DateTime': DateTime.now(),
      'SelectedAddress': selectedAddress,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
        id: data['Id'] as String,
        name: data['Name'] as String,
        phoneNumber: data['PhoneNumber'] as String,
        street: data['Street'] as String,
        city: data['City'] as String,
        state: data['State'] as String,
        postalCode: data['PostalCode'] as String,
        country: data['Country'] as String,
        selectedAddress: data['SelectedAddress'] as bool,
        dateTime: (data['DateTime'] as Timestamp).toDate());
  }

  // Create model from Firestore document with null-check for dateTime.
  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressModel(
      id: doc.id,
      name: data['Name'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      street: data['Street'] ?? '',
      city: data['City'] ?? '',
      state: data['State'] ?? '',
      postalCode: data['PostalCode'] ?? '',
      country: data['Country'] ?? '',
      dateTime: (data['DateTime'] as Timestamp?)?.toDate(),
      selectedAddress: data['SelectedAddress'] ?? false,
    );
  }

  @override
  String toString() {
    return '$street, $city, $state, $postalCode, $country';
  }
}
