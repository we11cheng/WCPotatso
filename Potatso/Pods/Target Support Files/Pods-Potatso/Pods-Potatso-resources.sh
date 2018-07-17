#!/bin/sh
set -e

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")

case "${TARGETED_DEVICE_FAMILY}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\"" || true
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH" || true
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HsUIResourceBundle.bundle"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ar.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/bg.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/bn.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ca.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/cs.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/da.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/de.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/el.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/en.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/es.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/fa.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/fi.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/fr.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/gu.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/he.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/hi.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/hr.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/hu.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/id.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/it.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ja.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/kn.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ko.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/lv.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ml.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/mr.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ms.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/nb-NO.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/nb.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/nl.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/pa.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/pl.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/pt.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ro.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ru.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/sk.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/sl.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/sv.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ta.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/te.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/th.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/tr.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/uk.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/vi.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/zh-Hans.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/zh-Hant.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSThemes/HelpshiftConfig.plist"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSThemes/HelpshiftConfigDark.plist"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HsUIResourceBundle.bundle"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ar.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/bg.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/bn.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ca.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/cs.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/da.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/de.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/el.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/en.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/es.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/fa.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/fi.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/fr.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/gu.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/he.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/hi.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/hr.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/hu.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/id.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/it.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ja.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/kn.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ko.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/lv.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ml.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/mr.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ms.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/nb-NO.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/nb.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/nl.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/pa.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/pl.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/pt.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ro.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ru.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/sk.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/sl.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/sv.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/ta.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/te.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/th.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/tr.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/uk.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/vi.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/zh-Hans.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSLocalization/zh-Hant.lproj"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSThemes/HelpshiftConfig.plist"
  install_resource "${PODS_ROOT}/Helpshift/helpshift-sdk-ios-v5.6.1/HSThemes/HelpshiftConfigDark.plist"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
