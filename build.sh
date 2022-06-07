FILE=apktool.jar
ZIPALIGN=/Users/pdesire/Library/Android/sdk/build-tools/33.0.0-rc1/zipalign
if [ -f "$FILE" ]; then
    echo "$FILE exists, not redownloading."
else
    echo "$FILE does not exist yet."
    echo "Obtaining APKTool 2.6.1..."
    wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.6.1.jar apktool.jar
fi    

if [ -d "dist" ]; then
    echo "Build already existing, clear old build..."
    rm -rf dist
fi 

echo " "
echo " "
echo "Start building overlays..."
mkdir dist
mkdir dist/raw
echo "Building android framework overlay..."
java -jar apktool.jar b android -o dist/raw/treble-overlay-sony-pdx206-unaligned.apk
echo "Building systemui overlay..."
java -jar apktool.jar b com.android.systemui -o dist/raw/treble-overlay-sony-pdx206-systemui-unaligned.apk
echo "Building settings overlay..."
java -jar apktool.jar b com.android.settings -o dist/raw/treble-overlay-sony-pdx206-settings-unaligned.apk

echo " "
echo " "
echo "Signing overlays with debug key..."
cp debug.keystore dist/raw
cd dist/raw
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore debug.keystore -storepass android treble-overlay-sony-pdx206-unaligned.apk androiddebugkey
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore debug.keystore -storepass android treble-overlay-sony-pdx206-systemui-unaligned.apk androiddebugkey
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore debug.keystore -storepass android treble-overlay-sony-pdx206-settings-unaligned.apk androiddebugkey
cd ../..

echo " "
echo " "
echo "Zipalign overlays..."
$ZIPALIGN -f -p 4 dist/raw/treble-overlay-sony-pdx206-unaligned.apk dist/treble-overlay-sony-pdx206.apk
$ZIPALIGN -f -p 4 dist/raw/treble-overlay-sony-pdx206-systemui-unaligned.apk dist/treble-overlay-sony-pdx206-systemui.apk
$ZIPALIGN -f -p 4 dist/raw/treble-overlay-sony-pdx206-settings-unaligned.apk dist/treble-overlay-sony-pdx206-settings.apk
echo "Building overlays done!"