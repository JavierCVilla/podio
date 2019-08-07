#!/bin/bash 

# Sets up the required environment to build and test podio.
# Relies on the LCG Releases to prepare the environment.


help(){
   echo "Usage: source init.sh [OPTION]"
   echo "Source an LCG view to set up the environment to build and test podio"
   echo ""
   echo "Options:"
   echo -e "  -c, --compiler COMPILER \tSource an LCG Release for the specified compiler"
   echo -e "  -e, --externals VERSION \tSource a given version of the LCG Releases"
   echo ""
   echo "Examples:"
   echo -e "source init.sh      \t# Sets the default values, gcc62 compiler and LCG_96"
   echo -e "source init.sh -c gcc8 \t# Sets the default LCG Release for gcc8"
   echo -e "source init.sh -c gcc8 -e LCG_94 \t# Sets gcc8 and LCG_94" 
   echo ""
}

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
        * | -h | --help) 
            help
            return 1
    esac
done 

# Detect current OS
TOOLSPATH=/cvmfs/fcc.cern.ch/sw/0.8.3/tools/
_OS=`python $TOOLSPATH/hsf_get_platform.py --get os`

# Version of the FCC Externals
# Default is 94.2.0 unless a different version is specified by command line
_LCG_EXTERNALS="${_EXTERNALS:-LCG_94}"

# Compiler
# Default is gcc62 unless a different compiler is specified by command line
_GCCTAG="${_COMPILER:-gcc62}"

# Platform
_PLATFORM="x86_64-$_OS-$_GCCTAG-opt"

# Setup script
setuppath="/cvmfs/sft.cern.ch/lcg/views/$_LCG_EXTERNALS/$_PLATFORM/setup.sh"

# source FCC externals
if test -f $setuppath ; then
   echo "Setting up external dependencies from $setuppath"
   source $setuppath
else
   echo "Setup script not found: $setuppath! "
   echo "Platforms available for the $_LCG_EXTERNALS version:"
   ls -1 /cvmfs/sft.cern.ch/lcg/views/$_LCG_EXTERNALS
   echo "Versions available for the $_PLATFORM platform:"
   find /cvmfs/sft.cern.ch/lcg/views -maxdepth 2 -iname "$_PLATFORM"
fi

# Remove argument variables
unset _EXTERNALS
unset _COMPILER
