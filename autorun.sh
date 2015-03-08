#!/usr/bin/env sh

cd vanguard/bin/

killall dart
../../dart/dart-sdk/bin/dart server.dart &

if which xdg-open > /dev/null
then
  xdg-open "http://localhost:8080/vanguard.html"
elif which gnome-open > /dev/null
then
  gnome-open "http://localhost:8080/vanguard.html"
fi
