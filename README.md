# Vanguard
A web-based, cloud hosted, scouting system for [FRC](http://www.usfirst.org/roboticsprograms/frc), using [THREE.js](threejs.org), and [Dart](https://www.dartlang.org/).

## Installing
1. Clone Vanguard or download the ZIP and extract. If you are running Linux and have Dart installed to the PATH, skip to the setup section.
2. Download the appropriate version of the Dart SDK from [here](https://www.dartlang.org/tools/download.html).
3. Extract the Dart SDK into `vanguard/dart` The path to the Dart SDK should be `dart/dart-sdk/bin/dart.exe`.

## Setup
1. Vanguard requires a list of matches and of robots in the form of CSV spreadsheets.
2. Add these manually by editing the `robots.csv` and `matches.csv` files found in `vanguard/data`. CSV files can be opened and edited by most spreadsheet programs; just remember to save as CSV no matter how much Excel tries to trick you not to.

## Running

### Easy Way

Run the server by clicking on `autorun.sh` (Linux/Mac) or `autorun.bat` (Windows).
The server will listen on TCP port 8080.

### Command Line

Navigate to Vanguard's directory and run autorun.
This will allow you to see all requests to the server and any error, so you can tell if Vanguard is working properly.

## Contact
Please report any bugs you find to the issues page above.
If you have questions contact me at erichspaker@gmail.com.
Any ideas or help are welcome.
