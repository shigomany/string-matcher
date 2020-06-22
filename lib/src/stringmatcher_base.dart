import 'package:stringmatcher/src/algorithm.dart';

import 'stringmatcher_value.dart';
import 'dart:core';
import 'dart:math';
//part of stringmatcher;

enum Term {
  char,
  word,
  ngram
}

class StringMatcher {

  String first_string;
  String second_string;
//  Why?
//  final _supportsTypes = <Type>[
//    String,
//    List<String>,
//  ];

  final int ngramValue;
  final Term term;
  final Algorithm algorithm;

  StringMatcher(this.term, this.algorithm, [this.ngramValue = 1]);

  StringMatcherValue similar(dynamic first, dynamic second) {
    // I wanted to create a variable with supported types (List<Type>),
    // but List<String> is not allowed.
    if(!(first is String || second is String) ||
       !(first is List<String> || second is List<String>) ||
       !(first is List<List<String>> || second is List<List<String>>)) {
      throw TypeError();
    }

    int firstLength, secondLength;

    var maxLength = max(first.length, second.length);
    var ratio = algorithm.getRatio(first, second, term);

    return StringMatcherValue(ratio, maxLength);
  }

  // ignore: missing_return
  StringMatcherValue partialSimilar(String first, String second) {
    throw UnimplementedError();
  }
}

