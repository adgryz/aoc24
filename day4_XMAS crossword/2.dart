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
      var isX = checkIfX(arr, i, j);
      if (isX) {
        count++;
      }
    }
  }

  return count;
}

bool checkIfX(List<List<String>> arr, int x, int y) {
  var isRight = checkRight(arr, x, y, 'MAS') || checkRight(arr, x, y, 'SAM');
  var isLeft = checkLeft(arr, x, y, 'MAS') || checkLeft(arr, x, y, 'SAM');
  return isRight && isLeft;
}

bool checkRight(List<List<String>> arr, int x, int y, String phrase) {
  if (y + 1 >= arr[0].length || y - 1 < 0 || x + 1 >= arr.length || x - 1 < 0) {
    return false;
  }

  if (arr[x - 1][y - 1] == phrase[0] &&
      arr[x][y] == phrase[1] &&
      arr[x + 1][y + 1] == phrase[2]) {
    return true;
  }

  return false;
}

bool checkLeft(List<List<String>> arr, int x, int y, String phrase) {
  if (y + 1 >= arr[0].length || y - 1 < 0 || x + 1 >= arr.length || x - 1 < 0) {
    return false;
  }

  if (arr[x - 1][y + 1] == phrase[0] &&
      arr[x][y] == phrase[1] &&
      arr[x + 1][y - 1] == phrase[2]) {
    return true;
  }

  return false;
}

Future<String> loadExample() async {
  const filePath = './example-2.txt';
  var text = await loadFile(filePath);
  return text;
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
