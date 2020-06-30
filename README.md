## StringMatcher
This is a library for fuzzy comparison of two strings. It supports 3 types of comparison - char, word, and ngram.

This library, in turn, is also a nice wrapper over various comparison algorithms that you can also implement yourself.

## Usage

Each instance of the class when calling 3 functions - `similar`, `partialSimilar`, `partialSimilarOne` returns a 
measure of similarity (StringMatcherValue) expressed in a `ratio`, `percent`, `distance`.

#### similar

This is a normal function that returns the result of comparing 2 strings.

```dart
import 'package:stringmatcher/stringmatcher.dart';

void main() {

  var s1 = 'fizz';
  var s2 = 'fizz';
  var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
  print(sim.similar(s1, s2).ratio);
}
```
Output:
```
1.0
```

#### partialSimilar

This is a normal function that returns the result of comparing the source string among a list of strings.

```dart
import 'package:stringmatcher/stringmatcher.dart';

void main() {

  var source = 'buzz';
  var listStrings = ['dart', 'flutter', 'anime', 'buzz'];

  var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
  print(sim.partialSimilar(source, listStrings,
        (a, b) => a.ratio.compareTo(b.ratio),
        selector: (x) => x.percent,
        limit: 3));
}
```

Output:
```
[[buzz, 100.0], [flutter, 14.28571428571429], [dart, 0.0]]
```

#### partialSimilarOne
The same as partial Similar, but returns the very first element instead of a list.

```dart
import 'package:stringmatcher/stringmatcher.dart';

void main() {

  var source = 'buzz';
  var listStrings = ['dart', 'flutter', 'anime', 'buzz'];

  var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
  print(sim.partialSimilarOne(source, listStrings,
        (a, b) => a.ratio.compareTo(b.ratio),
        selector: (x) => x.percent));
}
```

Output:
```
[buzz, 100.0]
```

## Custom algorithm

You can also implement your own algorithms.

```dart
import 'package:stringmatcher/stringmatcher.dart';

class FakeAlgorithm implements Algorithm {
  @override
  double getRatio(List<String> first, List<String> second) {
    return 1.0;
  }

}

void main() {

  var s1 = 'fizz';
  var s2 = 'buzz';
  var sim = StringMatcher(term: Term.char, algorithm: FakeAlgorithm());
  print(sim.similar(s1, s2).ratio);
}
```

Output:
```
1.0
```

## Support types

When calling functions of the similar type, you can pass certain data types as 2 strings.

StringMatcher supports the following types:

- String
- List\<String\>
- ~~List<List\<String\>>~~ (Not implemented)

