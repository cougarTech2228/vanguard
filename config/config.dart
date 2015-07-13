import 'dart:io';
import 'dart:math' as Math;
import 'package:xml/xml.dart' as XML;
import 'csv_utils.dart';


Knowledge brain = new Knowledge("path/file/FIXTHIS");
Data data = new Data("path/data.csv.FIX");

class Data{
	Map<int, Robot> robots;

	String path;
	File file;

	Data(this.path){
		file = new File(path);
		file.createSync();
		String text = file.readAsStringSync();
		List<List<String>> csv = new CsvConverter.Excel().parse(text);

		load(csv);
	}

	void load(csv){
		for(List<String> col in csv){
			Record record = new Record.fromList(col);
			robot(record.team).log(record);
		}
	}

	void save(){
		List<List<String>> csv = [];

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

class Robot{
	int number;
	List<Stat_Value> stats = [];
	List<Record> matches = [];
  bool calculated_flg = false;

	Robot(this.number){
    calculate();
	}

	List<List<String>> csv(){
		List<List<String>> data = [];

		for(Record record in matches){
			data.add(record.csv());
		}

		return data;
	}

	void calculate(){
	  stats = [];
		for(Stat stat in brain.listStats()){
			Stat_Value value = new Stat_Value(number, stat.calculateValue(this), stat);
			stats.add(value);
	    calculated_flg = true;
		}

	}

	void log(Record record){
	   matches.add(record);
	   calculated_flg = false;
	}
}

class Record{
	int team;
	int match;
  List<String> data = [];

	Record(this.team, this.match){}

	Record.fromList(List<String> list){
     team = int.parse(list[0]);
     match = int.parse(list[1]);
     data.addAll(list.sublist(2));

	}

	List<String> csv(){
		return data..insert(0,match.toString())..insert(0,team.toString());
	}
}

class Stat_Value{
	int robot;
	int value;
	int field;
	int type;
	String name;

	Stat_Value(this.robot, this.value, Stat stat){
		field = stat.field;
		type = stat.type;
		name = stat.name;
	}
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
			num min = num.parse(element.attributes[1].value);
			num max = num.parse(element.attributes[2].value);
			bool nostat = element.attributes[3].value == "true";
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

	List<Stat> listStats(){
		List<Stat> stats = [];
		for(Field field in fields){
			for(Stat stat in field.statistics){
				stats.add(stat);
			}
		}
		return stats;
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
	bool noStat = false; //set to true for text

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
	num deviation=0;

	num average = 0;

	Stat(this.field, this.type, this.name);

	bool log(delta){
		//delta = value of choosen - value of other
		deviation = ((delta - weight).abs()  + deviation*counter) / (counter+1);
		weight = (delta + weight*counter) / (counter+1);
		counter++;

		return true;
	}

	num calculateAverage(List<Robot> robots){
		for(Robot robot in robots){
			average += calculateValue(robot);
		}

		average /= robots.length;
		return average;
	}

	num calculateValue(Robot robot){
		List values=[];
		for(Record match in robot.matches){
			values.add(match.data[field]);
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
		"deviation"
	];

	static num analyze(int method, List<num> values){
	  if(values.length == 0){
	    return -1;
	  }

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
		}

		throw Exception;
	}

	static num minimum(List<num> values){
		num min = values[0];

		for(var value in values){
			min = Math.min(min, value);
		}

		return min;
	}

	static num maximum(List<num> values){
		num max = values[0];

		for(var value in values){
			max = Math.max(max, value);
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
			total += Math.pow(value - mean , 2);
		}

		return total/values.length;
	}

  static num deviation(List<num> values){
    return Math.sqrt(variation(values));
  }
}

