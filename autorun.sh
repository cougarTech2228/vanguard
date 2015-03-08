#!/bin/bash

cd vanguard/bin/

killall dart
dart server.dart &

if which xdg-open > /dev/null
then
  xdg-open "http://127.0.0.1:8080/vanguard.html"
elif which gnome-open > /dev/null
then
  gnome-open "http://127.0.0.1:8080/vanguard.html"
fi
