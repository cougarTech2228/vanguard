import 'dart:io';
import 'csv_utils.dart';

File matchFile = new File(root + "matches.csv");
List<List<String>> matchCSV = new CsvConverter.Excel().parse(matchFile.readAsStringSync());

void  main(List<String> arguments){
  matchCSV.forEach((l){
    l.forEach((e)=> print(parse(e));
  });
}