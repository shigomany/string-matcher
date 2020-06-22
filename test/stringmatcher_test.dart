import 'package:stringmatcher/src/algs/levenshtein.dart';
import 'package:stringmatcher/stringmatcher.dart';
import 'package:test/test.dart';


void main() {
  group('A group of tests', () {
    var sim = StringMatcher(Term.char, Levenshtein());

    setUp(() {
//      awesome = Awesome();
    });

    test('Levenstein Similar Ratio', () {

      expect(sim.similar('test1', 'test1').ratio, 1);
    });
  });
}
