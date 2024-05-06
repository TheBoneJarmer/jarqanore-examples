#!/bin/bash

BIN_JAVAC="$JAVA_HOME/bin/javac"
BIN_JAR="$JAVA_HOME/bin/jar"
BIN_JAVADOC="$JAVA_HOME/bin/javadoc"

OUT_DIR="./out"
CP_JAVAC=""
CP_JAR=""

cd lib
CP_FILES="`find . -type f -name "*.jar"`"

for CP_FILE in $CP_FILES
do
  CP_FILE_BASENAME="`basename $CP_FILE`"

  CP_JAVAC="$CP_JAVAC:../../lib/$CP_FILE_BASENAME"
  CP_JAR="$CP_JAR $CP_FILE_BASENAME"
done
cd ..

echo "Compiling example window"
cd src/window
JAVAC_OUTPUT=$($BIN_JAVAC -cp $CP_JAVAC -d ../../$OUT_DIR/window -g `find . -type f -name "*.java"` 2>&1)
JAVAC_OUTPUT_EXITCODE=$?

if [[ JAVAC_OUTPUT_EXITCODE -ne 0 ]];
then
	echo "$JAVAC_OUTPUT"
	exit $JAVAC_OUTPUT_EXITCODE
fi
cd ../..

echo "Compiling example sprites"
cd src/sprites
JAVAC_OUTPUT=$($BIN_JAVAC -cp $CP_JAVAC -d ../../$OUT_DIR/sprites -g `find . -type f -name "*.java"` 2>&1)
JAVAC_OUTPUT_EXITCODE=$?

if [[ JAVAC_OUTPUT_EXITCODE -ne 0 ]];
then
	echo "$JAVAC_OUTPUT"
	exit $JAVAC_OUTPUT_EXITCODE
fi
cd ../..

echo "Compiling example fonts"
cd src/fonts
JAVAC_OUTPUT=$($BIN_JAVAC -cp $CP_JAVAC -d ../../$OUT_DIR/fonts -g `find . -type f -name "*.java"` 2>&1)
JAVAC_OUTPUT_EXITCODE=$?

if [[ JAVAC_OUTPUT_EXITCODE -ne 0 ]];
then
	echo "$JAVAC_OUTPUT"
	exit $JAVAC_OUTPUT_EXITCODE
fi
cd ../..

echo "Generating manifest"
cd out
echo "Main-Class: be.labruyere.examples.App" > APP.mf
echo "Class-Path: " >> APP.mf

for CP_FILE in $CP_JAR
do
    echo " $CP_FILE " >> APP.mf
done

echo "" >> APP.mf

echo "Generating jars"
cd window
JAR_OUTPUT=$($BIN_JAR -cfm ../jarqanore-window.jar ../APP.mf `find . -type f -name *".class"` 2>&1)
JAR_OUTPUT_EXITCODE=$?

if [[ JAR_OUTPUT_EXITCODE -ne 0 ]];
then
	echo "$JAR_OUTPUT"
	exit $JAR_OUTPUT_EXITCODE
fi
cd ..

cd sprites
JAR_OUTPUT=$($BIN_JAR -cfm ../jarqanore-sprites.jar ../APP.mf `find . -type f -name *".class"` 2>&1)
JAR_OUTPUT_EXITCODE=$?

if [[ JAR_OUTPUT_EXITCODE -ne 0 ]];
then
	echo "$JAR_OUTPUT"
	exit $JAR_OUTPUT_EXITCODE
fi
cd ..

cd fonts
JAR_OUTPUT=$($BIN_JAR -cfm ../jarqanore-fonts.jar ../APP.mf `find . -type f -name *".class"` 2>&1)
JAR_OUTPUT_EXITCODE=$?

if [[ JAR_OUTPUT_EXITCODE -ne 0 ]];
then
	echo "$JAR_OUTPUT"
	exit $JAR_OUTPUT_EXITCODE
fi
cd ..

echo "Copying resources"
cp -r ../lib/*.jar .
cp -r ../assets/ .

echo "Cleanup"
rm `find ./assets -type f -name "*.xcf"`
rm -r window/
rm -r sprites/
rm -r fonts/
rm *.mf
