import 'dart:io';

void main() async {
  try {
    var isExample = true;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var result = 0;

    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  String toString() => '($x,$y)';
}

List<List<String>> readBoard(String boardStr) {
  return boardStr.split('\n').map((line) => line.split('')).toList();
}

void printBoard(List<List<String>> board) {
  var boardStr = board.map((line) => line.join('')).join(('\n'));
  print(boardStr);
  print('\n');
}

Future<String> loadExample() async {
  const filePath = './example-2.txt';
  return await loadFile(filePath);
}

Future<String> loadProblem() async {
  const filePath = './problem-2.txt';
  return await loadFile(filePath);
}

Future<String> loadFile(filePath) async {
  try {
    var file = File(filePath);
    var text = await file.readAsString();
    return text;
  } catch (e) {
    print('Error reading file: $e');
  }

  return "";
}
