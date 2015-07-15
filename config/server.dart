import 'dart:io';
import 'csv_utils.dart';
import 'config.dart';
import 'dart:convert';

int PORT = 1555;
String CONFIG_PATH = "config.xml";
String DATA_PATH = "data.csv";


Knowledge brain;
Data data;

void main(List<String> arguments) {
  brain = new Knowledge(CONFIG_PATH);
  set_brain(brain);
  //print(JSON.encode(brain).replaceAll(",", ",\n").replaceAll('\\',"").replaceAll("{", "\n{"));
  data = new Data(DATA_PATH);

  server_init(arguments.isNotEmpty ? int.parse(arguments[0]) : PORT);
}

void server_init(int port) {
  HttpServer.bind(InternetAddress.ANY_IP_V6, port).then((server) {
    print("Serving at ${server.address}:${server.port}");
    server.listen((HttpRequest request) {
      try {
        print("received request: " + request.method + ": " + request.uri.toString());
        addCorsHeaders(request);
        dispatch(request);
      }

      catch (error, stack) {
        print(error);
        print(stack);
      }

    }).onError((error, stack) {
      print(error);
      print(stack);
    });
  }).catchError((Exception error, stack){
    if(error.runtimeType == SocketException){
      print("Error: could not start server, unable to bind port");
      print("Do you have another instance of the server running?");
    }else{
      print(error);
      print(stack);
    }
  });
}

void dispatch(HttpRequest request){
  if(request.method == "GET"){
    if(request.uri.pathSegments[0] == "data"){
        if(request.uri.pathSegments[1] == "robot"){
            int number = int.parse(request.uri.pathSegments[2]);
            Robot robot = data.robot(number)..calculate();
            request.response.write(robot.toJson());
            request.response.close();
        }
    }

    else if(request.uri.pathSegments[0] == "config"){
      request.response.write(JSON.encode(brain));
      request.response.close();
    }

  }

  else if(request.method == "POST"){
      request.response.close();
      //TODO
  }
}
//a temporary fix
void addCorsHeaders(HttpRequest req) {
   //print(req.headers.value("Origin"));
   req.response.headers.add("Access-Control-Allow-Credentials", "true");
   req.response.headers.add("Access-Control-Allow-Origin", req.headers.value("Origin"));
   req.response.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS, HEAD, LOGIN, LOGOUT, SEARCH");
   req.response.headers.add("Access-Control-Allow-Headers", req.headers.value("Access-Control-Request-Headers"));
   req.response.headers.add("Access-Control-Expose-Headers", "status");

   //Access-Control-Max-Age
   //res.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, TYPE, USER, PASS, STATUS");
}