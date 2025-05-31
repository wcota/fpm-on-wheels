set -ex

PROJECT_DIR="$1"

if [[ "$(uname -m)" == "x86_64" ]]; then
    export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-10.9}
    GFOR_ARCH="x86_64"
else
    export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-11.0}
    GFOR_ARCH="arm64"
fi

echo "@@@ MACOSX_DEPLOYMENT_TARGET:" $MACOSX_DEPLOYMENT_TARGET
echo "@@@ GFOR_ARCH:" $GFOR_ARCH
# ---------- install gfortran ----------

source $PROJECT_DIR/tools/wheels/gfortran_utils.sh
install_gfortran

# ---------- export compiler + rpath for subsequent CMake & delocate ----------
GFOR_ROOT="/opt/gfortran-darwin-${GFOR_ARCH}-native"
echo "FC=${GFOR_ROOT}/bin/gfortran" >>"$GITHUB_ENV"
echo "LDFLAGS=-L${GFOR_ROOT}/lib -Wl,-rpath,${GFOR_ROOT}/lib -mmacosx-version-min=${MACOSX_DEPLOYMENT_TARGET}" >>"$GITHUB_ENV"
echo "F90=${GFOR_ROOT}/bin/gfortran" >>"$GITHUB_ENV"
echo "F95=${GFOR_ROOT}/bin/gfortran" >>"$GITHUB_ENV"

echo "@@@ FC:" "${GFOR_ROOT}/bin/gfortran"
echo "@@@ LDFLAGS:" "-L${GFOR_ROOT}/lib -Wl,-rpath,${GFOR_ROOT}/lib"

# Cannot pass these variables to the wheel building process since before-build
# executes in a subprocess. So we print them out and manually set them in
# pyproject.toml
echo "@@@ FC:" $FC
echo "@@@ FC_ARM64_LDFLAGS:" $FC_ARM64_LDFLAGS
