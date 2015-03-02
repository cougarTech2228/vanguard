import 'dart:io';
import 'package:csv_utils/csv_utils.dart';

String root = "../data/";
File robotListFile = new File(root + "robots.csv")..createSync(recursive: true);
List robotListCSV = new CsvConverter.Excel().parse(robotListFile.readAsStringSync());

String templateString = new File(root + "template.csv").readAsStringSync();
List template = new CsvConverter.Excel().parse(templateString);

void main() {
     HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
          print("Serving at ${server.address}:${server.port}");
          server.listen((HttpRequest request) {
               print("received request: " + request.method + ": " + request.uri.toString());
               try {
                    if (request.method == "POST") {
                         post_handler(request);
                    } else if (request.method == "GET") {
                         get_handler(request);
                    }
               } catch (e, s) {
                    print(e);
                    print(s);
               }
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
          File imgFile = new File(root + number + "/picture.jpeg");

          //List<int> imgData = CryptoUtils.base64StringToBytes(request.);
          //imgFile.create().then((f) => f.writeAsBytes(imgData));
          
          request.response.close();

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
          }

          robotDataFile.writeAsStringSync(new CsvConverter.Excel().compose(robotDataCSV));
          request.response.statusCode = HttpStatus.OK;
          request.response.close();
     }
}

void get_handler(HttpRequest request) {
     if (request.uri.path != "/") {
          //request is for a page/file
          if (request.uri.path.contains(".html")) {
               request.response.headers.add("Content-Type", "text/html; charset=UTF-8");
          }
          if (request.uri.path.contains(".js")) {
               request.response.headers.add("Content-Type", "text/javascript; charset=UTF-8");
          }

          try {
               request.response.write(new File("../src" + request.uri.path).readAsStringSync());
          } catch (e) {
               request.response.write("404 not found... \n \t ...darn");
          }

          request.response.close();

     } else if (request.uri.queryParameters["type"] == "data") {
          String number = request.uri.queryParameters["number"];
          while (number.length < 4) {
               number = "0" + number;
          }
          request.response.write(new File(root + number + "/data.csv").readAsStringSync());
          request.response.close();

     } else if (request.uri.queryParameters["type"] == "robots") {
          request.response.write(new File(root + "robots.csv").readAsStringSync());
          request.response.close();

     } else if (request.uri.queryParameters["type"] == "picture") {
          String number = request.uri.queryParameters["number"];
          String path = root + number + "/picture.jpeg";
          File file = new File(path);
          file.readAsBytes().then((raw) {
               request.response.headers.set('Content-Type', 'image/jpeg');
               request.response.headers.set('Content-Length', raw.length);
               request.response.add(raw);
               request.response.close();
          });

     } else if (request.uri.queryParameters["type"] == "matches") {
          request.response.write(new File(root + "match.csv").readAsStringSync());
          request.response.close();

     } else {
          request.response.close();
     }
}
