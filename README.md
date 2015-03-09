# Vanguard
Vanguard: a web-based, cloud hosted scouting system for FRC competitions

#installing
1. clone vanguard or download the zip and extract
(if you are running linux and have dart installed to the PATH skip to setup)
2 download the appropriat version of the dart-sdk from here: https://www.dartlang.org/tools/download.html
3. extract the dart-sdk into vanguard/dart
(the path to the dart-sdk should be dart/dart-sdk/bin/dart.exe)

#setup
1. vanguard requires a list of matches, and of robots in the form of csv spreadsheets
2. add these manually by editing the robots.csv and matches.csv files found in /vanguard/data 
(csv files can be opened and edited by most spreadsheet programs, just remember to save as csv, no matter how much excel tries to trick you not to)

#running

1. easy way

run the server by clicking on autorun.sh(Linux/Mac) or autorun.bat(Windows)
(the server will listen on port 8080)

2. command line

navigate to vanguard's directory and run autorun
(this will allow you to see all requests to the server and any error, so you can tell if vanguard is working properly)

#contact
please report any bugs you find to the issues page above
if you have questions contact me at erichspaker@gmail.com  
any ideas or help are welcome
