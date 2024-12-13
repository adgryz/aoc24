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
