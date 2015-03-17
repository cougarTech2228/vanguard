# Vanguard
A web-based, cloud hosted, scouting system for [FRC](http://www.usfirst.org/roboticsprograms/frc), using [THREE.js](http://threejs.org), and [Dart](https://www.dartlang.org/).

## Installing
1. Clone Vanguard or download the ZIP and extract. If you are running Linux and have Dart installed to the PATH, skip to the setup section.
2. Download the appropriate version of the Dart SDK from [here](https://www.dartlang.org/tools/download.html).
3. Extract the Dart SDK into `vanguard/dart` The path to the Dart SDK should be `dart/dart-sdk/bin/dart.exe`.

## Setup
1. Vanguard requires a list of matches and of robots in the form of CSV spreadsheets.
2. Add these manually by editing the `robots.csv` and `matches.csv` files found in `vanguard/data`. CSV files can be opened and edited by most spreadsheet programs; just remember to save as CSV no matter how much Excel tries to trick you not to. (you can easily add data to the csv files by copying and pasting from the Blue Alliance website)

## Running

### Easy Way

Run the server by clicking on `autorun.sh` (Linux/Mac) or `autorun.bat` (Windows).
The server will listen on TCP port 8080.

### Command Line

Navigate to Vanguard's directory and run autorun.
This will allow you to see all requests to the server and any error, so you can tell if Vanguard is working properly.

##Using

1. Have the server running anda web browser open to localhost:8080/vanguard.html
2. Search through teams by typing in number, name, or location
3. click on a team (or press enter) to bring up more info
4. press esc to close info
5. press the "?"-"/" key to enter command mode
6. immediately press f to go to the todo screen. here you can see teams which still need to be pit scouted or photographed
7. click on a team to mark them, use this to keep track of which teams have been scouted but not yet beenentered into the computer
8. press "?" again (don't hold shift) and press "a" to go to picture submission
9. click on the button to upload a photo, and then type in the team number and press submit
10. press "?" and then "s" to go to input
11. here is where you enter the data. select either pit or match and simply type the numbers right off the scouting sheet (the sheet is provided in the repo under the sheet directory) you should make one entry fo each column of data. Some fields will require you to preface zeros, so pay attention to the text at the bottom of the screen, and the error messages in the top left.
12. press enter to submit data
13. you can now press "?" "d" to return to the data display
14. press "?" "p" to toggle picture mode, in this mode you can view and scroll through all the robot images.

##modifying
1. To make modifications to the code it is recomended that you use the dart editor from darts website
2. If you have problems with autorun you can also run the serber from the dart editor, see dart's page for instructions on how to run a dart file.
 
##comming soon
1. configuration
2. analytics
3. lists
4. mobile forms for scouting directly into the system
--for more see the projects TODO file

## Contact
Please report any bugs you find to the issues page above, I will try to fix problems as soon as possible.
If you have questions or problems contact me at erichspaker@gmail.com.
Any ideas or help are welcome.
