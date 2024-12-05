import 'dart:io';

void main() async {
  try {
    var isExample = false;
    var example = await loadExample();
    var problem = await loadProblem();
    var text = isExample ? example : problem;
    var result = 0;

    var lines = text.split('\n');
    var arr = lines.map((line) => line.split("")).toList();
    result = countAll(arr);
    print(result);
  } catch (e) {
    print('Error reading file: $e');
  }
}

int countAll(List<List<String>> arr) {
  var count = 0;
  var linesCount = arr.length;
  var lineLength = arr[0].length;

  for (var i = 0; i < linesCount; i++) {
    for (var j = 0; j < lineLength; j++) {
      var isHorizontal = checkIfHorizontal(arr, i, j, 'XMAS');
      var isBackwardsHorizontal = checkIfHorizontal(arr, i, j, 'SAMX');
      var isVertical = checkIfVertical(arr, i, j, 'XMAS');
      var isBackwardsVertical = checkIfVertical(arr, i, j, 'SAMX');
      var isRightDiagonal = checkIfRightDiagonal(arr, i, j, 'XMAS');
      var isRightBackwardsDiagonal = checkIfRightDiagonal(arr, i, j, 'SAMX');
      var isLeftDiagonal = checkIfLeftDiagonal(arr, i, j, 'XMAS');
      var isLeftBackwardsDiagonal = checkIfLeftDiagonal(arr, i, j, 'SAMX');

      var current = isHorizontal +
          isBackwardsHorizontal +
          isVertical +
          isBackwardsVertical +
          isRightDiagonal +
          isRightBackwardsDiagonal +
          isLeftDiagonal +
          isLeftBackwardsDiagonal;
      count += current;
    }
  }

  return count;
}

int checkIfHorizontal(List<List<String>> arr, int x, int y, String phrase) {
  if (y + 3 >= arr[x].length) {
    return 0;
  }

  if (arr[x][y] == phrase[0] &&
      arr[x][y + 1] == phrase[1] &&
      arr[x][y + 2] == phrase[2] &&
      arr[x][y + 3] == phrase[3]) {
    return 1;
  }

  return 0;
}

int checkIfVertical(List<List<String>> arr, int x, int y, String phrase) {
  if (x + 3 >= arr.length) {
    return 0;
  }
  if (arr[x][y] == phrase[0] &&
      arr[x + 1][y] == phrase[1] &&
      arr[x + 2][y] == phrase[2] &&
      arr[x + 3][y] == phrase[3]) {
    return 1;
  }
  return 0;
}

int checkIfRightDiagonal(List<List<String>> arr, int x, int y, String phrase) {
  if (x + 3 >= arr.length || y + 3 >= arr[x].length) {
    return 0;
  }

  if (arr[x][y] == phrase[0] &&
      arr[x + 1][y + 1] == phrase[1] &&
      arr[x + 2][y + 2] == phrase[2] &&
      arr[x + 3][y + 3] == phrase[3]) {
    return 1;
  }
  return 0;
}

int checkIfLeftDiagonal(List<List<String>> arr, int x, int y, String phrase) {
  if (x + 3 >= arr.length || y - 3 < 0) {
    return 0;
  }
  if (arr[x][y] == phrase[0] &&
      arr[x + 1][y - 1] == phrase[1] &&
      arr[x + 2][y - 2] == phrase[2] &&
      arr[x + 3][y - 3] == phrase[3]) {
    return 1;
  }
  return 0;
}

Future<String> loadExample() async {
  const filePath = './example-1.txt';
  return await loadFile(filePath);
}

Future<String> loadProblem() async {
  const filePath = './problem-1.txt';
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
