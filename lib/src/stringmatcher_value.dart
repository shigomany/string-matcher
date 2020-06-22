
class StringMatcherValue {
  final double _ratio;
  final int _maxLength;

  double get ratio => _ratio;

  int get distance => ((1.0 - _ratio) * _maxLength).ceil();

  double get percent => _ratio * 100.0;

  StringMatcherValue(this._ratio, this._maxLength);
}