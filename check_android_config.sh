#!/bin/bash

echo "🔍 Checking Android build environment..."

BUILD_GRADLE_FILE="./android/app/build.gradle"

if [[ ! -f "$BUILD_GRADLE_FILE" ]]; then
  echo "❌ Could not find build.gradle file in android/app"
  exit 1
fi

# Extract values using sed (macOS-compatible)
ndkVersion=$(sed -n 's/.*ndkVersion *= *"\([^"]*\)".*/\1/p' "$BUILD_GRADLE_FILE")
compileSdk=$(sed -n 's/.*compileSdk *= *\([0-9]*\).*/\1/p' "$BUILD_GRADLE_FILE")
minSdk=$(sed -n 's/.*minSdk *= *\([0-9]*\).*/\1/p' "$BUILD_GRADLE_FILE")

echo "📦 NDK Version:         ${ndkVersion:-Not found}"
echo "📱 Compile SDK:         ${compileSdk:-Not found}"
echo "📉 Min SDK:             ${minSdk:-Not found}"

echo ""
echo "🔎 Compatibility Check:"

if [[ -z "$ndkVersion" || "$ndkVersion" < "23" ]]; then
  echo "⚠️  NDK version is missing or older than v23. Consider upgrading."
fi

if [[ -z "$minSdk" || "$minSdk" -lt 21 ]]; then
  echo "⚠️  minSdk is missing or less than 21. Might cause native issues."
fi

if [[ -n "$compileSdk" && -n "$ndkVersion" && "$compileSdk" -lt 33 && "$ndkVersion" == 26* ]]; then
  echo "⚠️  compileSdk is less than 33, which might cause issues with NDK 26."
else
  echo "✅ Your compileSdk and NDK version seem compatible"
fi