
rm -rf build/* || mkdir build 

cd build

echo "WORKSPACE: `pwd`"

QMAKE_PATH=/opt/tools/Qt5.12.8/5.12.8/gcc_64/bin/qmake
echo "qmake: ${QMAKE_PATH}"

cmake .. -GNinja \
    -DCMAKE_INSTALL_PREFIX=./AppDir/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DQV2RAY_TRANSLATION_PATH=QApplication::applicationDirPath\(\)+"/../share/qv2ray/lang"
cmake --build . --parallel $(nproc)
cmake --install .

cd AppDir
mkdir -p ./usr/{lib,optional}/
mkdir -p ./usr/optional/libstdc++/
mkdir -p ./usr/optional/libgcc_s/
mkdir -p ./usr/plugins/platforminputcontexts/
wget -c https://github.com/dkmos2016/ext-linux-bin/raw/main/appimage/AppRun-patched-x86_64 -O AppRun
wget -c https://github.com/dkmos2016/ext-linux-bin/raw/main/appimage/exec-x86_64.so -O ./usr/optional/exec.so

# need Qt5_15
wget https://github.com/Qv2ray/qt-pkg/releases/download/bruh/libfcitx5platforminputcontextplugin.so -O ./usr/plugins/platforminputcontexts/libfcitx5platforminputcontextplugin.so


# 根据libfcitx5platforminputcontextplugin.so选择Qt版本
cp -rv /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitx5platforminputcontextplugin.so ./usr/plugins/platforminputcontexts/libfcitx5platforminputcontextplugin.so 

cp -fv /usr/lib/x86_64-linux-gnu/libstdc++.so.6 ./usr/optional/libstdc++/
cp -fv /lib/x86_64-linux-gnu/libgcc_s.so.1 ./usr/optional/libgcc_s/
cp -fv /usr/lib/x86_64-linux-gnu/{libssl.so.1.1,libcrypto.so.1.1} ./usr/lib/
cp -fv /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so ./usr/plugins/platforminputcontexts/
chmod a+x AppRun
cd ..
# wget https://github.com/probonopd/linuxdeployqt/releases/download/6/linuxdeployqt-6-x86_64.AppImage
# chmod +x ./linuxdeployqt-6-x86_64.AppImage
# ./linuxdeployqt-6-x86_64.AppImage AppDir/usr/share/applications/qv2ray.desktop \
#     -appimage \
#     -no-strip \
#     -always-overwrite \
#     -extra-plugins=iconengines,imageformats,platforminputcontexts

wget https://github.com/probonopd/linuxdeployqt/releases/download/5/linuxdeployqt-5-x86_64.AppImage
chmod +x ./linuxdeployqt-5-x86_64.AppImage
./linuxdeployqt-5-x86_64.AppImage AppDir/usr/share/applications/qv2ray.desktop \
    -appimage \
    -no-strip \
    -always-overwrite \
    -extra-plugins=iconengines,imageformats,platforminputcontexts \
    -qmake=$QMAKE_PATH

mv ./Qv2ray*.AppImage ./Qv2ray.AppImage