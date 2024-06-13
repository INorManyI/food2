/// A subsystem for reading data about food's details about it's nutrients
/// passed from the food repository
class Nutrient
{
  final double _energy;
  final double _protein;
  final double _fat;
  final double _carbohydrate;

  Nutrient(this._energy, this._protein, this._fat, this._carbohydrate);

  /// Retrieves food's energy in kilocalories
  double getEnergyInKcal() => _energy;

  /// Retrieves food's protein in grams
  double getProteinInGram() => _protein;

  /// Retrieves food's fat in grams
  double getFatInGram() => _fat;

  /// Retrieves food's carbohydrate in grams
  double getCarbohydrateInGram() => _carbohydrate;
}
