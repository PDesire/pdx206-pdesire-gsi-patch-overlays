FILE=apktool.jar
if [ -f "$FILE" ]; then
    echo "$FILE exists, not redownloading."
else
    echo "$FILE does not exist yet."
    echo "Obtaining APKTool 2.6.1..."
    wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.6.1.jar apktool.jar
fi    




echo "Start building overlays..."
mkdir dist
mkdir dist/raw
echo "Building android framework overlay..."
java -jar apktool.jar b com.android.systemui -o dist/treble-overlay-sony-pdx206-systemui-unaligned.apk
echo "Building systemui overlay..."
java -jar apktool.jar b android -o dist/treble-overlay-sony-pdx206-unaligned.apk

echo " "
echo " "
echo "Signing overlays with debug key..."
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore debug.keystore dist/raw/treble-overlay-sony-pdx206-unaligned.apk androiddebugkey
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore debug.keystore dist/raw/treble-overlay-sony-pdx206-systemui-unaligned.apk androiddebugkey

echo " "
echo " "
echo "Zipalign overlays..."
zipalign -f -p 4 dist/raw/treble-overlay-sony-pdx206-unaligned.apk dist/treble-overlay-sony-pdx206-systemui.apk
zipalign -f -p 4 dist/raw/treble-overlay-sony-pdx206-systemui-unaligned.apk dist/treble-overlay-sony-pdx206-systemui.apk
echo "Building overlays done!"