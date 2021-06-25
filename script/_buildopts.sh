#!/bin/bash
###############################################################################
# Copyright (C) Intel Corporation
#
# SPDX-License-Identifier: MIT
###############################################################################
# User friendly consistant parameter parsing

# Takes one parameter, the name of a variable
# Echos Name followed by value or "(not defined)"
# depending on state of the named variable
print_var () {
  varname=$1
  # We pendantilcly check for null here
  # this is not needed in code that calls this library
  if [ -z ${!varname+x} ]
  then
    echo "   ${varname}: null"
  else
    echo "   ${varname}: \"${!varname}\""
  fi
}

# Set script folder
SCRIPT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 || exit 1 ; pwd -P )"

# Set root folder
PROJ_DIR="$( dirname "${SCRIPT_DIR}" )"

# Clear options
# Note: options will always contain text when set, so
# simple "non-zero length" tests are sufficant to test if
# option is set. (ex: [ -n "${HELP_OPT}" ])
unset HELP_OPT
unset GPL_OPT
COFIG_OPT=Release
unset ARCH_OPT
unset BOOTSTRAP_OPT

# Read information about origin script before parsing command line
while [ $# -gt 0 ]; do
    case $1 in
        "--" )
            shift
            break
            ;;
        "--name" )
            ORIG_SCRIPT_NAME="$2"
            shift
            ;;
        "--desc" )
            ORIG_SCRIPT_DESC="$2"
            shift
            ;;
        * )
            echo "Unrecognized option $1"
            HELP_OPT=yes
            break
            ;;
    esac
    if [ $# -gt 0 ]
    then
        shift
    fi
done

# Read command line options
while [ $# -gt 0 ]; do
    case $1 in
        "--gpl" )
            GPL_OPT=yes
            ;;
        "gpl" )
            GPL_OPT=yes
            ;;
        "--config" )
            COFIG_OPT="$2"
            shift
            ;;
        "debug" )
            COFIG_OPT="Debug"
            shift
            ;;
        "-A" )
            ARCH_OPT="$2"
            shift
            ;;
        "--bootstrap" )
            BOOTSTRAP_OPT=yes
            ;;
        "--help" )
            HELP_OPT=yes
            ;;
        "-h" )
            HELP_OPT=yes
            ;;
        * )
            echo "Unrecognized option $1"
            HELP_OPT=yes
            break
            ;;
    esac
    if [ $# -gt 0 ]
    then
        shift
    fi
done

# Print usage message
if [ -n "${HELP_OPT}" ]
then
  echo "Usage: ${ORIG_SCRIPT_NAME} [options]"
  echo "  --gpl            Include componentes using GPL licensing"
  echo "  --config CONFIG  Build configuration"
  echo "  -A ARCH          Target architecture"
  echo "  --bootstrap      Include bootstrap steps"
  echo "  --help, -h       Show this help message"
  echo ""
  echo "Depricated options"
  echo "  debug            same as \"--config Debug\""
  echo "  gpl              same as \"--gpl\""
  echo ""
  echo "CONFIG may be: Release, Debug"
  echo "ARCH may be: x86_64, x86_32"
  echo ""
  echo "${ORIG_SCRIPT_DESC}"
  exit 0
fi

# Equivalent parameters to what this was called with for further calls
FORWARD_OPTS=
if [ -n "${GPL_OPT}" ]
then
  FORWARD_OPTS="${FORWARD_OPTS} --gpl"
fi
if [ -n "${COFIG_OPT}" ]
then
  FORWARD_OPTS="${FORWARD_OPTS} --config ${COFIG_OPT}"
fi
if [ -n "${ARCH_OPT}" ]
then
  FORWARD_OPTS="${FORWARD_OPTS} -A ${ARCH_OPT}"
fi
if [ -n "${BOOTSTRAP_OPT}" ]
then
  FORWARD_OPTS="${FORWARD_OPTS} --bootstrap"
fi

# echo "Option Summary:"
# print_var HELP_OPT
# print_var GPL_OPT
# print_var COFIG_OPT
# print_var ARCH_OPT
# print_var BOOTSTRAP_OPT
# print_var FORWARD_OPTS
