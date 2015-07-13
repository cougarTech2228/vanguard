import 'dart:io';
import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'package:xml/xml.dart' as XML;
import 'csv_utils.dart';

class Data{
	Map<int, Robot> robots;

	static String path = "data.csv";
	File file = new File(path);

	Data(){
		file.createSync();
		String text = file.readAsStringSync();
		List<List<String>> csv = new CsvConverter.Excel().parse(text);

		load(csv);
	}

	void load(csv){
		for(List<String> row in csv){
			int team = int.parse(row[0]);
			int match = int.parse(row[1]);
			Record record = new Record(team, match);
			record.add(record.sublist(2));
			robot(team).add(record);
		}

	}

	void save(){
		List<List> csv = [];

		for(Robot robo in robots.values){
			csv.addAll(robo.csv());
		}

		file.writeAsString(new CsvConverter.Excel().compose(csv));
	}

	Robot robot(int number){
		if(robots.keys.contains(number)){
			return robots[number];
		}

		robots[number] = new Robot(number);
		return robots[number];
	}
}

class Robot extends PolyList{
	int number;

	Robot(this.number){}

	List<List> csv(){
		List<List> data = [];

		for(Record record in this){
			data.add(record.csv());
		}

		return data;
	}
}

class Record extends PolyList{
	int team;
	int match;

	Record(this.team, this.match){}

	List csv(){
		return this.toList()..insert(0,match)..insert(0,team);
	}
}

class PolyList extends ListBase{
  List list = [];
  num get length => list.length;
      set length(num l) => list.length = l;

  operator [](int i) => list[i];
  operator []=(int i, var v) => list[i]=v;
}

class Knowledge{
	List<Field> fields;
	XML.XmlDocument config;

	Knowledge(String path){
		File conf = new File(path);
		String text = conf.readAsStringSync();
		config = XML.parse(text);
		List<XML.XmlElement> fe =  config.findAllElements("field");
		for(XML.XmlElement element in fe){
			String name = element.attributes[0].value;
			num min = int.parse(element.attributes[1].value);
			num max = int.parse(element.attributes[2].value);
			bool nostat = element.attributes[3].value == "true" ? true : false;
			fields.add(new Field(name, max, min, fields.length, nostat));
		}
	}

	bool log(int field, int stat, num delta){
		return fields[field].log(stat, delta);
	}

	void update(List<List<num>> deltas){
		for(List<num> entry in deltas){
			log(entry[0],entry[1],entry[2]);
		}
	}
}

//field types

class Field{
	String type = "number";

	String name;
	int index;

	num max;
	num min;

	List<Stat> statistics = [];
	bool noStat = false; //set to true for text, tea number etc.

	Field(this.name, this.max, this.min, this.index, this.noStat){
		if(noStat){
			for(int i = 0 ; i < Analyzer.TYPES.length ; i++){
				statistics.add(new Stat(this.index, i, Analyzer.TYPES[i] + " " + name));
			}
		}
	}

	bool log(int stat, num delta){
		return statistics[stat].log(delta);
	}
}

class Stat{
	int field;
	int type;
	String name;

	int counter = 0;
	num weight = 0;
	num deviation= 0;

	num average = 0;

	Stat(this.field, this.type, this.name);

	bool log(delta){
		//delta = value of choosen - value of other
		deviation = ((delta - weight).abs()  + deviation*counter) / (counter+1);
		weight = (delta + weight*counter) / (counter+1);
		counter++;

		return true;
	}

	num calculateAverage(List<Robot> robots, {nochange: false}){
	  num avg = 0 ;
		for(Robot robot in robots){
		  avg += calculateValue(robot);
		}
		avg /= robots.length;
		if(!nochange){
		  average = avg;
		}
		return avg;
	}

	num calculateValue(Robot robot){
		List<num> values = [];
		for(Record match in robot){
			values.add(match[field]);
		}
		return Analyzer.analyze(type, values);
	}
}

class Analyzer{
	static List<String> TYPES = [
		"minimum",
		"maximum",
		"range",
		"average",
		"variation"
	];

	static num analyze(int method, List<num> values){
		switch(method){
			case 0:
				return minimum(values);
			case 1:
				return maximum(values);
			case 2:
				return range(values);
			case 3:
				return average(values);
			case 4:
				return variation(values);
			default:
			  return 0;
		}
	}

	static num minimum(List<num> values){
		num min = values[0];

		for(var value in values){
			min = math.min(min, value);
		}

		return min;
	}

	static num maximum(List<num> values){
		num max = values[0];

		for(var value in values){
			max = math.max(max, value);
		}

		return max;
	}

	static num range(List<num> values){
		return maximum(values) - minimum(values);
	}

	static num average(List<num> values){
		num total = 0;

		for(var value in values){
			total += value;
		}

		return total/values.length;
	}

	static num variation(List<num> values){
		num mean = average(values);
		num total = 0;

		for(var value in values){
			total += math.pow(value - mean , 2);
		}

		return total/values.length;
	}

}

