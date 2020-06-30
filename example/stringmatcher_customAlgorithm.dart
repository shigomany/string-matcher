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