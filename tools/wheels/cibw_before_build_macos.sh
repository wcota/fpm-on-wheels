set -ex

PROJECT_DIR="$1"

if [[ "$(uname -m)" == "x86_64" ]]; then
    export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-10.9}
else
    export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-11.0}
fi

if [ -n "$GITHUB_ENV" ]; then
    brew unlink gcc || true
fi

source $PROJECT_DIR/tools/wheels/gfortran_utils.sh
install_gfortran

eval "$(gfortran_get_vars)"
{
    echo "FC=$FC"
    echo "F90=$FC"
    echo "F95=$FC"
    echo "LDFLAGS=$LDFLAGS"
    echo "CFLAGS=-mmacosx-version-min=$MACOSX_DEPLOYMENT_TARGET"
    echo "FFLAGS=$CFLAGS"
} >>"$GITHUB_ENV"

# Cannot pass these variables to the wheel building process since before-build
# executes in a subprocess. So we print them out and manually set them in
# pyproject.toml
echo "@@@ FC:" $FC
echo "@@@ FC_ARM64_LDFLAGS:" $FC_ARM64_LDFLAGS
