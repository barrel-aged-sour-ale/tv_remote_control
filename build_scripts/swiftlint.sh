if [ "${CONFIGURATION}" = "Debug" ]; then
  echo "SwiftLint started"
  Pods/SwiftLint/swiftlint --quiet --path "${1:-.}"
  if [ $? -ne 0 ];
  then
    echo "SwiftLint check failed"
    exit 1
  else
    echo "SwiftLint finished"
    exit 0
  fi
fi