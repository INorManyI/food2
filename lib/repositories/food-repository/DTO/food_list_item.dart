/// A subsystem to read the data from the food repository
/// needed to generate a list of foods.
class FoodListItem
{
  final String _id;
  final String _name;
  final String? _thumbnailUrl;

  FoodListItem(this._id, this._name, this._thumbnailUrl);

  /// Retrieves food's identifier
  String getId() => _id;

  /// Retrieves food's name
  String getName() => _name;

  /// Retrieves food's thumbnail's URL
  String? getThumbnail() => _thumbnailUrl;
}
