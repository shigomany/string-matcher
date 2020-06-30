import 'package:stringmatcher/stringmatcher.dart';

void main() {

  var source = 'buzz';
  var listStrings = ['dart', 'flutter', 'anime', 'buzz'];

  var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
  print(sim.partialSimilarOne(source, listStrings,
          (a, b) => a.ratio.compareTo(b.ratio),
      selector: (x) => x.percent));
}