//import 'package:stringmatcher/src/algs/levenshtein.dart';
import 'package:stringmatcher/stringmatcher.dart';

void main() {

  var sw = Stopwatch();
  
  var longString1 = List.filled(9999, 'A').fold('', (previousValue, element) => previousValue + element);
  var longString2 = List.filled(9999, 'A').fold('', (previousValue, element) => previousValue + element) + 'B';
  sw.start();
  var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
  var result = sim.similar(longString1, longString2);
  sw.stop();
  print('ratio: ${result.ratio}');
  print('percent: ${result.percent}');
  print('distance: ${result.distance}');

  print('Time: ${sw.elapsedMilliseconds}ms');
}
