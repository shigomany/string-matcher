import 'package:stringmatcher/stringmatcher.dart';

void main() {

  var s1 = 'fizz';
  var s2 = 'fizz';
  var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
  print(sim.similar(s1, s2).ratio);
}
