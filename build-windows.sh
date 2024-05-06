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

  CP_JAVAC="$CP_JAVAC;../lib/$CP_FILE_BASENAME"
  CP_JAR="$CP_JAR lib/$CP_FILE_BASENAME"
done
cd ..

echo "Compiling java sources"
cd src
JAVAC_OUTPUT=$($BIN_JAVAC -cp $CP_JAVAC -d ../$OUT_DIR -g `find ./com/ -type f -name "*.java"` 2>&1)
JAVAC_OUTPUT_EXITCODE=$?

if [[ JAVAC_OUTPUT_EXITCODE -ne 0 ]];
then
	echo "$JAVAC_OUTPUT"
	exit $JAVAC_OUTPUT_EXITCODE
fi
cd ..

echo "Generating manifests"
cd $OUT_DIR
echo "Main-Class: com.reapenshaw.server.App" > SERVER.mf
echo "Class-Path: " >> SERVER.mf

for CP_FILE in $CP_JAR
do
    echo " $CP_FILE " >> SERVER.mf
done

echo "" >> SERVER.mf

echo "Main-Class: com.reapenshaw.client.App" > CLIENT.mf
echo "Class-Path: " >> CLIENT.mf

for CP_FILE in $CP_JAR
do
    echo " $CP_FILE " >> CLIENT.mf
done

echo "" >> CLIENT.mf

echo "Generating jars"
JAR_OUTPUT=$($BIN_JAR -cfm rsw-server.jar ./SERVER.mf `find ./com/ -type f -name *".class"` 2>&1)
JAR_OUTPUT_EXITCODE=$?

if [[ JAR_OUTPUT_EXITCODE -ne 0 ]];
then
	echo "$JAR_OUTPUT"
	exit $JAR_OUTPUT_EXITCODE
fi

JAR_OUTPUT=$($BIN_JAR -cfm rsw-client.jar ./CLIENT.mf `find ./com/ -type f -name *".class"` 2>&1)
JAR_OUTPUT_EXITCODE=$?

if [[ JAR_OUTPUT_EXITCODE -ne 0 ]];
then
	echo "$JAR_OUTPUT"
	exit $JAR_OUTPUT_EXITCODE
fi

echo "Copying resources"
cp -r ../lib/ .
cp -r ../assets/ .
cp -r ../maps/ .
cp -r ../*.db .

echo "Cleaning up"
rm `find ./assets -type f -name "*.xcf"`
rm -r ./com/
rm *.mf
