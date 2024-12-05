import 'dart:io';

void main() async {
// const filePath = './example-1.txt';
  const filePath = './problem-1.txt';
  var file = File(filePath);
  var text = await file.readAsString();

  var parsed = text.split('\n');
  List<int> left = [];
  List<int> right = [];
  for (var i = 0; i < parsed.length; i++) {
    var values = parsed[i].split('   ');
    left.add(int.parse(values[0]));
    right.add(int.parse(values[1]));
  }

  left.sort();
  right.sort();
  var diff = 0;
  for (var i = 0; i < left.length; i++) {
    var distI = left[i] - right[i];
    diff += distI.abs();
  }

  print(diff);
}
