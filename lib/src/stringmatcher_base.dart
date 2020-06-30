import 'package:stringmatcher/src/algorithm.dart';
import 'package:meta/meta.dart';
import 'stringmatcher_value.dart';
import 'package:stringmatcher/src/extends.dart';

import 'dart:core';
import 'dart:collection';
import 'dart:math';
import 'package:tuple/tuple.dart';

typedef MatchComparer = int Function(StringMatcherValue a, StringMatcherValue b);
typedef ValueSelector = num Function(StringMatcherValue value);

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
//    <List<String>>[].runtimeType: () => throw UnimplementedError()
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

  /// Find best match elements in [secondValues] and sort by [comparer].
  /// Returns the number of elements equal to [limit]
  // ignore: missing_return
  List<Tuple2<dynamic, dynamic>> partialSimilar(
      dynamic first,
      Iterable<dynamic> secondValues,
      MatchComparer comparer,
      {int limit = 5, ValueSelector selector}) {

    StringMatcherValue maxValue;
    var result = ListQueue<Tuple2<dynamic, StringMatcherValue>>();

    for(var el in secondValues) {
      var strings = _parseByTerm(first, el, term, separators, ngramValue);
      var ratio = algorithm.getRatio(strings.item1, strings.item2);
      var maxLength = max(strings.item1.length, strings.item2.length);
      var currentMatcher = StringMatcherValue(ratio, maxLength);
      if (maxValue == null) {
        maxValue = StringMatcherValue(ratio, maxLength);
        result.add(Tuple2(el, maxValue));
        continue;
      }
      if (comparer(currentMatcher, maxValue) == 1) {
        maxValue = currentMatcher;
        result.addFirst(Tuple2(el, currentMatcher));
      }
      else if (comparer(currentMatcher, maxValue) < 1) {
        result.addLast(Tuple2(el, currentMatcher));
      }
    }

    if (selector != null) {
      return result.take(limit).map((e) => Tuple2(e.item1, selector(e.item2))).toList();
    }

    return result.take(limit).toList();
  }


  Tuple2<dynamic, dynamic> partialSimilarOne(
      dynamic first,
      Iterable<dynamic> secondValues,
      MatchComparer comparer,
      {ValueSelector selector}) {
    dynamic string;
    StringMatcherValue maxValue;

    for(var el in secondValues) {
      var strings = _parseByTerm(first, el, term, separators, ngramValue);
      var ratio = algorithm.getRatio(strings.item1, strings.item2);
      var maxLength = max(strings.item1.length, strings.item2.length);
      var currentMatcher = StringMatcherValue(ratio, maxLength);
      if (maxValue == null) {
        maxValue = StringMatcherValue(ratio, maxLength);
        string = el;
        continue;
      }
      if (comparer(currentMatcher, maxValue) == 1) {
        maxValue = currentMatcher;
        string = el;
      }
    }

    if (selector != null) {
      return Tuple2(string, selector(maxValue));
    }

    return Tuple2(string, maxValue);
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

