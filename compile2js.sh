#!/bin/bash
cd web
dart2js -c -o"google_plus.dart.js" google_plus.dart
dart2js -c -o"out/google_plus.dart.js" out/google_plus.dart
dart2js -c -o"out/google_plus.html_bootstrap.dart.js" out/google_plus.html_bootstrap.dart
