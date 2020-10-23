#!/bin/bash

function installDeps() {
  sudo apt-get update && upgrade --show-upgraded
  apt-get install -y git nodejs npm make gcc
  cd /opt && mkdir dweb && cd dweb
}

function installArisen() {
  cd /opt/dweb
  git clone https://github.com/arisenio/arisen.git
  cd arisen
  bash ./arisen_build.sh
}

function installDD() {
  cd /opt/dweb
  git clone https://github.com/distributedweb/ddrive-daemon.git
  cd ddrive-daemon
  npm install -g
}

function installArisenCDT() {
  cd /opt/dweb
  git clone https://github.com/arisenio/arisen.cdt.git
  cd arisen.cdt
  ./build.sh
  sudo ./install.sh
}

function installNova() {
  echo "Installer coming soon"
}

function installDdnsCli() {
  echo "Installer coming soon"
}

function installAll() {
  installDD && installNova && installDdnsCli && installArisen && installArisenCDT
}

function intro() {
  echo "Lunar Installer v1.0.0"
  echo "==================="
  echo "Install dWeb developer tools all from one place."
  echo "==================="
  echo "1. All Tools"
  echo "2. aOS, AriseCLI and aWalletd"
  echo "3. dDrive Daemon"
  echo "4. dDNS CLI"
  echo "5. Arisen Contract Development Toolkit (CDT)"
  echo "6. Nova (Create Private dWeb)"
  getChoice
}

function getChoice() {
  read -p "What would you like to install?: " CHOICE
  case "$CHOICE" in
    1) installDeps && installAll ;;
    2) installDeps && installArisen ;;
    3) installDeps && installDD ;;
    4) installDeps && installDdnsCli ;;
    5) installDeps && installArisenCDT ;;
    6) installDeps && installNova ;;
    *)  echo "Invalid choice. Choice must be a number from the menu." && intro ;;
  esac
}

function fail () {
  msg=$1
  echo "================"
  echo "Error: $msg" 1>&2
  exit 1
}

function install () {
  # bash check
  [!"$BASH_VERSION"] && fail "Please use bash instead"
  GET=""
  if which curl > /dev/null; then
    GET="curl"
    GET="$GET --fail -# -L"
  elif which wget > /dev/null; then
    GET="wget"
    GET="$GET -qO-"
  else
    fail "Neither wget or curl are installed."
  fi

  # check OS
  case `uname -s` in
  Darwin) OS="macos";;
  Linux) OS="linux";;
  *) fail "Unsupported Operating System: $(uname -s)";;
  esac

  # check processor
  if uname -m | grep 64 > /dev/null; then
    ARCH="x64"
  else
    fail "Only ARCH x64 is currently supported by Lunar. Your arch is: $(uname -m)"
  fi
}

install && intro