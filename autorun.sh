#!/usr/bin/env sh

cd vanguard/bin/

killall dart

if which dart > /dev/null
then
  dart server.dart &
else
  ../../dart/dart-sdk/bin/dart server.dart &
fi

if which xdg-open > /dev/null
then
  xdg-open "http://localhost:8080/vanguard.html"
elif which gnome-open > /dev/null
then
  gnome-open "http://localhost:8080/vanguard.html"
fi
