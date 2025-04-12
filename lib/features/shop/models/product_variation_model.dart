class ProductVariationModel {
  final String id;
  String sku;
  String image;
  String? description;
  double price;
  double salePrice;
  int stock;
  Map<String, String> attributeValues;

  ProductVariationModel({
    required this.id,
    required this.attributeValues,
    this.sku = '',
    this.image = '',
    this.description = '',
    this.price = 0.0,
    this.salePrice = 0.0,
    this.stock = 0,
  });

  /// Creates an empty variation for default or error cases.
  static ProductVariationModel empty() =>
      ProductVariationModel(id: '', attributeValues: {});

  /// Returns true if the variation is considered empty (using the ID check).
  bool get isEmpty => id.isEmpty;

  /// Convert the model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'SKU': sku,
      'Image': image,
      'Description': description,
      'Price': price,
      'SalePrice': salePrice,
      'Stock': stock,
      'AttributeValues': attributeValues,
    };
  }

  /// Creates a ProductVariationModel from a JSON map (e.g., from a Firestore document).
  factory ProductVariationModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ProductVariationModel.empty();
    return ProductVariationModel(
      id: data['Id'] ?? '',
      sku: data['SKU'] ?? '',
      image: data['Image'] ?? '',
      description: data['Description'] ?? '',
      price: double.tryParse(data['Price'].toString()) ?? 0.0,
      salePrice: double.tryParse(data['SalePrice'].toString()) ?? 0.0,
      stock: data['Stock'] ?? 0,
      attributeValues: data['AttributeValues'] != null
          ? Map<String, String>.from(data['AttributeValues'])
          : {},
    );
  }
}
