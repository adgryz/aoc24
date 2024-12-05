import 'dart:io';

void main() async {
// const filePath = './example-1.txt';
  const filePath = './problem-1.txt';
  var file = File(filePath);
  var text = await file.readAsString();

  var parsed = text.split('\n');
  List<int> left = [];
  List<int> right = [];
  Map<int, int> similarities = Map();
  var similarity = 0;

  for (var i = 0; i < parsed.length; i++) {
    var values = parsed[i].split('   ');
    left.add(int.parse(values[0]));
    right.add(int.parse(values[1]));
  }

  for (var i = 0; i < parsed.length; i++) {
    var current = left[i];
    var cachedSimilarity = similarities[current];
    if (cachedSimilarity != null) {
      similarity += cachedSimilarity;
    } else {
      var sameCount = 0;
      right.forEach((r) {
        if (r == current) {
          sameCount++;
        }
      });
      var newSimilarity = sameCount * current;
      similarities[current] = newSimilarity;
      similarity += newSimilarity;
    }
  }

  print(similarity);
}
