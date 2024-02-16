#!/bin/bash
#flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
flutter pub get && dart run build_runner build

openapi-generator-cli generate -i http://localhost:8080/v3/api-docs -g dart -o /Users/mac/AndroidStudioProjects/kenmack/kenmack_api
#cd expira_api
#flutter pub run build_runner build --delete-conflicting-outputs