import 'dart:io';

void main() async {
  // const filePath = './example-1.txt';
  const filePath = './problem-1.txt';
  var file = File(filePath);
  var text = await file.readAsString();
  var reports = text
      .split('\n')
      .map((str) => str.split(' ').map((v) => int.parse(v)).toList())
      .toList();

  var goodReports = 0;

  reports.forEach((report) {
    var isReportOk = checkReportVariations(report);
    if (isReportOk) {
      goodReports++;
    }
  });

  print(goodReports);
}

bool checkReportVariations(report) {
  var ogGood = checkIfGoodReport(report);
  if (ogGood) {
    return ogGood;
  } else {
    for (var i = 0; i < report.length; i++) {
      var reportVariant = getVariation(report, i);
      var variantGood = checkIfGoodReport(reportVariant);
      if (variantGood) {
        return variantGood;
      }
    }
    return false;
  }
}

List<int> getVariation(report, indexToRemove) {
  return [
    ...report.sublist(0, indexToRemove),
    ...report.sublist(indexToRemove + 1)
  ];
}

bool checkIfGoodReport(report) {
  var isSeriesIncreasing = report[1] > report[0];
  for (var i = 1; i < report.length; i++) {
    var isCurrentIncreasing = report[i] > report[i - 1];
    var isTrendKept = isCurrentIncreasing == isSeriesIncreasing;
    var diff = (report[i] - report[i - 1]).abs();
    var isDiffInRange = diff >= 1 && diff <= 3;
    if (!isTrendKept || !isDiffInRange) {
      return false;
    }
  }

  return true;
}
