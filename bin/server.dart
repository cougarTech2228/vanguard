import 'dart:io';
import 'package:csv_utils/csv_utils.dart';

String root = "../data/";
File robotListFile = new File(root + "robots.csv")..createSync(recursive: true);
List<List<String>> robotListCSV = new CsvConverter.Excel().parse(robotListFile.readAsStringSync());

String templateString = new File(root + "template.csv").readAsStringSync();
List<List<String>> template = new CsvConverter.Excel().parse(templateString);

File matchFile = new File(root + "matches.csv");
List<List<String>> matchCSV = new CsvConverter.Excel().parse(templateString);

void main() {
     HttpServer.bind(InternetAddress.ANY_IP_V4, 8080).then((server) {
     //HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
          print("Serving at ${server.address}:${server.port}");
          server.listen((HttpRequest request) {
              try{
               print("received request: " + request.method + ": " + request.uri.toString());
                if (request.method == "POST") {
                     post_handler(request);
                } else if (request.method == "GET") {
                     get_handler(request);
                }
              }catch(error, stack){
                print(error);
                print(stack);
                print("satan");
              }
          }).onError((error, stack){
               print(error);
               print(stack);
          });
     });
}

void post_handler(HttpRequest request) {
     String number = request.uri.queryParameters["number"];
     while (number.length < 4) {
          number = "0" + number;
     }

     String type = request.uri.queryParameters["type"];

     if (type == "picture") {
          File imgFile = new File(root + number + "/picture." + request.uri.queryParameters["filetype"]);
          List<int> bytes =[];
          request.listen((data){
            bytes.addAll(data);
          })..onDone((){
            imgFile.create(recursive:true).then((f) => f.writeAsBytes(bytes));
            request.response.close();
          })..onError(print);
     } else {
          File robotDataFile = new File(root + number + "/data.csv")..createSync(recursive: true);
          List robotDataCSV = new CsvConverter.Excel().parse(robotDataFile.readAsStringSync());

          if (robotDataCSV.length < template.length) {
               robotDataCSV = new CsvConverter.Excel().parse(templateString);
          }

          if (type == "pit") {
               //List data = new List<List<String>>.generate(3, (i)=>new List<String>(15));
               List data = new List<String>(12);
               data[0] = number;
               data[1] = request.uri.queryParameters["drive"];
               data[2] = request.uri.queryParameters["tote"];
               data[3] = request.uri.queryParameters["can"];
               data[4] = request.uri.queryParameters["stack"];
               data[5] = request.uri.queryParameters["litter"];
               data[6] = request.uri.queryParameters["pneumatics"];
               data[7] = request.uri.queryParameters["vision"];
               data[8] = request.uri.queryParameters["encoder"];
               data[9] = request.uri.queryParameters["range"];
               data[10] = request.uri.queryParameters["gyro"];
               data[11] = request.uri.queryParameters["comment"];
               robotDataCSV[2] = data;
          } else if (type == "match") {
               List data = new List<String>(12);
               data[0] = request.uri.queryParameters["match"];
               data[1] = request.uri.queryParameters["alliance"];
               data[2] = request.uri.queryParameters["tote"];
               data[3] = request.uri.queryParameters["can"];
               data[4] = request.uri.queryParameters["stack"];
               data[5] = request.uri.queryParameters["litter"];
               data[6] = request.uri.queryParameters["landfill"];
               data[7] = request.uri.queryParameters["playerstation"];
               data[8] = request.uri.queryParameters["steptotes"];
               data[9] = request.uri.queryParameters["stepcans"];
               data[10] = request.uri.queryParameters["vote"];
               data[11] = request.uri.queryParameters["comment"];
               robotDataCSV.add(data);
               
               castVote(request.uri.queryParameters["match"], number);
          }

          robotDataFile.writeAsStringSync(new CsvConverter.Excel().compose(robotDataCSV));
          request.response.statusCode = HttpStatus.OK;
          request.response.close();
     }
     logEntry(type,number);

}

//UNTESTED
void castVote(String match, String robot){
  match = zeros(match,3);
  robot = zeros(robot,4);
  
  List<String> robots = matchCSV.firstWhere((e)=>zeros(e[0],3)==match)..removeAt(0);
  robots.forEach((number){
    number = zeros(number,4);
    
    File robotDataFile = new File(root + number + "/data.csv")..createSync(recursive: true);
    List robotDataCSV = new CsvConverter.Excel().parse(robotDataFile.readAsStringSync());
    int total = int.parse(robotDataCSV[4][2]);
    total++;
    robotDataCSV[4][2] = total.toString();
    robotDataFile.writeAsStringSync(new CsvConverter.Excel().compose(robotDataCSV));
  });
      
  File robotDataFile = new File(root + robot + "/data.csv")..createSync(recursive: true);
  List robotDataCSV = new CsvConverter.Excel().parse(robotDataFile.readAsStringSync());
  int total = int.parse(robotDataCSV[4][1]);
  total++;
  robotDataCSV[4][1] = total.toString();
  robotDataFile.writeAsStringSync(new CsvConverter.Excel().compose(robotDataCSV));
}

String zeros(String str, int length){
  while (str.length < length) {
     str = "0" + str;
  }
  return str;
}

void get_handler(HttpRequest request) {
     if (request.uri.path != "/") {
          //request is for a page/file
          File file = new File("../src" + request.uri.path);
          //print(request.headers);
          
          if (request.uri.path.contains(".html")) {
               request.response.headers.add("Content-Type", "text/html; charset=UTF-8");
          }
          if (request.uri.path.contains(".js")) {
               request.response.headers.add("Content-Type", "text/javascript; charset=UTF-8");
          }
          if (request.uri.path.contains(".css")) {
               request.response.headers.add("Content-Type", "text/css; charset=UTF-8");
          }
         
          if(request.uri.queryParameters["type"] == "image"){
               List<int> raw =file.readAsBytesSync();
               request.response.headers.set('Content-Type', 'image/jpeg');
               request.response.headers.set('Content-Length', raw.length);
               request.response.add(raw);
               
          }else{
               
               try {
                    request.response.write(file.readAsStringSync());
               } catch (e) {
                    request.response.write("404 not found... \n \t ...darn");
               }
          }

          request.response.close();

     } else if (request.uri.queryParameters["type"] == "data") {
          String number = request.uri.queryParameters["number"];
          while (number.length < 4) {
               number = "0" + number;
          }
          
          File robotFile = new File(root + number + "/data.csv");
          if(robotFile.existsSync()){
            request.response.write(robotFile.readAsStringSync());
          }
          request.response.close();

     } else if (request.uri.queryParameters["type"] == "robots") {
          request.response.write(new File(root + "robots.csv").readAsStringSync());
          request.response.close();

     } else if (request.uri.queryParameters["type"] == "picture") {
          String number = request.uri.queryParameters["number"];
          while (number.length < 4) {
               number = "0" + number;
          }          
          
          String path = root + number + "/picture.png";
          File file = new File(path);
          if(!file.existsSync()){
               String path = root + number + "/picture.jpg";
               file = new File(path);
          }
          
          if(!file.existsSync()){
              file = new File("../src/loading.gif");
          }
          
          List<int> raw = file.readAsBytesSync();
          request.response.headers.set('Content-Type', 'image/jpeg');
          request.response.headers.set('Content-Length', raw.length);
          request.response.add(raw);
          request.response.close();

     } else if (request.uri.queryParameters["type"] == "matches") {
          request.response.write(new File(root + "match.csv").readAsStringSync());
          request.response.close();

     } else {
          request.response.close();
     }
}

void logEntry(type, number){
  robotListCSV.forEach((List<String> row){
    String text = row[0];
    while (text.length < 4) {
          text = "0" + text;
    }             
                  
    if(text==number){
      if(type=="pit"){
        row[6] = "1";
      }           
      if(type=="picture"){
        row[5] = "1";
      }
    }
  });
  
  robotListFile.writeAsStringSync(new CsvConverter.Excel().compose(robotListCSV));

}
