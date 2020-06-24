import 'package:stringmatcher/src/algorithm.dart';
import 'package:meta/meta.dart';
import 'stringmatcher_value.dart';
import 'package:stringmatcher/src/extends.dart';
import 'dart:core';
import 'dart:math';
import 'package:tuple/tuple.dart';


enum Term {
  char,
  word,
  ngram
}

class StringMatcher {

  String first_string;
  String second_string;
  
  final _supportsTypes = <Type, Function>{
    String: _stringTypeParser,
    <String>[].runtimeType: () => _listStringTypeParser,
    <List<String>>[].runtimeType: () => throw UnimplementedError()
  };

  final int ngramValue;
  final Term term;
  final Algorithm algorithm;
  final List<String> separators;

  /// Constructor are required [term] and [algorithm].
  /// If you choose term ngram, you can also choose [ngramValue] (default 2).
  /// For other terms, such as word and ngram you can chose separators for words (default ' '(space))
  StringMatcher({@required this.term, @required this.algorithm, this.ngramValue = 2, this.separators = const [' ']});


  /// Compare [first] and [second] elements and returns
  /// the result as [StringMasterValue], which is wrapper over
  /// values: ratio, percent, distance.
  StringMatcherValue similar(dynamic first, dynamic second) {

    if(_supportsTypes.keys.every((element) => first.runtimeType != element ||
                                              second.runtimeType != element)) {
      throw UnsupportedError('Supported types: String, List<String>, List<List<String>>');
    }

    var strings = _parseByTerm(first, second, term, separators, ngramValue);

    var maxLength = max(strings.item1.length, strings.item2.length);
    var ratio = algorithm.getRatio(strings.item1, strings.item2);

    return StringMatcherValue(ratio, maxLength);
  }

  /// Perform callback functions in [_supportsTypes]
  /// which are mapped to types
  // ignore: missing_return
  Tuple2<List<String>, List<String>> _parseByTerm(
      dynamic first,
      dynamic second,
      Term term,
      List<String> splitters,
      int ngramValue) {
    // Search elements in [_supportTypes]
    for(var entry in _supportsTypes.entries) {
      // Check type
      if(first.runtimeType == entry.key) {
        return Tuple2(entry.value(first, term, splitters, ngramValue),
                      entry.value(second, term, splitters, ngramValue));
      }
    }
  }

  // ignore: missing_return
  StringMatcherValue partialSimilar(String first, String second) {
    throw UnimplementedError();
  }

  /// Type parsing for Iterable<String>
  // ignore: missing_return
  static List<String> _listStringTypeParser(
      dynamic value,
      Term term,
      [List<String> splitters = const [' '],
      int ngramValue]) {
    switch(term) {
      case Term.char:
        return value as List<String>;
      case Term.word:
        return value as List<String>;
      case Term.ngram:
        return (value as List<String>)
            ..selectMany(ngramValue)
            ..map((e) => (e as List<String>).join(' '));
    }
  }

  /// Type parsing for String
  // ignore: missing_return
  static List<String> _stringTypeParser(
      dynamic value,
      Term term,
      [List<String> splitters = const [' '],
       int ngramValue]) {
    switch(term) {
      case Term.char:
        return (value as String).split('');
      case Term.word:
        return (value as String).splitMany(splitters);
      case Term.ngram:
        return (value as String).ngramSplit(splitters, ngramValue);
    }
  }

}

