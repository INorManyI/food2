import 'nutrient.dart';

/// A subsystem for reading data about food details
/// passed from the food repository
class Food
{
  final String _id;
  final String _name;
  final Nutrient _nutrient;
  final String _category;
  final String? _thumbnailUrl;

  Food(this._id, this._name, this._nutrient, this._category, this._thumbnailUrl);

  /// Retrieves food's identifier
  String getId() => _id;

  /// Retrieves food's name
  String getName() => _name;

  /// Retrieves food's category
  String getCategory() => _category;

  /// Retrieves food's nutrient
  Nutrient getNutrient() => _nutrient;

  /// Retrieves food's thumbnail's URL
  String? getThumbnail() => _thumbnailUrl;
}
