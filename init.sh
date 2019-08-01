#!/bin/bash 

# Sets up the required environment to build podio

# Read arguments
while [[ $# -gt 0 ]]
do
    arg="$1"
    case $arg in
        -c | --compiler)
            _COMPILER="$2"
            shift # past argument
            shift # past value
        ;;
        -e | --externals)
            _EXTERNALS="$2"
            shift 
            shift
        ;;
        *) # unknown option
    esac
done 

# Detect current OS
TOOLSPATH=/cvmfs/fcc.cern.ch/sw/0.8.3/tools/
_OS=`python $TOOLSPATH/hsf_get_platform.py --get os`

# Version of the FCC Externals
# Default is 94.2.0 unless a different version is specified by command line
_FCC_EXTERNALS="${_EXTERNALS:-94.2.0}"

# Compiler
# Default is gcc62 unless a different compiler is specified by command line
_GCCTAG="${_COMPILER:-gcc62}"

# Platform
_PLATFORM="x86_64-$_OS-$_GCCTAG-opt"

# Setup script
setuppath="/cvmfs/fcc.cern.ch/sw/views/releases/externals/$_FCC_EXTERNALS/$_PLATFORM/setup.sh"

# source FCC externals
if test -f $setuppath ; then
   echo "Setting up FCC externals from $setuppath"
   source $setuppath
else
   echo "Setup script not found: $setuppath! "
   echo "Platforms available for this version:"
   ls -1 /cvmfs/fcc.cern.ch/sw/views/releases/externals/$_FCC_EXTERNALS
   echo "Versions available for this platform:"
   ls -1 /cvmfs/fcc.cern.ch/sw/views/releases/externals/*/$_PLATFORM/setup.sh
fi

# Remove argument variables
unset _EXTERNALS
unset _COMPILER

# Define path to podio
# CMakeLists.txt relies on some environment variables
export PODIO=$FCCVIEW
