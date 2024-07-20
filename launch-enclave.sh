#!/usr/bin/env bash

set -e
GRAMINE=gramine-sgx
REQUEST=gramine-sgx-ias-request
VERIFY=gramine-sgx-ias-verify-report

# === make alpacon & alpamon ===
make clean > /dev/null
echo -e "\n\e[0;33m###############################################################"
echo -e "\nLaunching Alpamon enclave . . .\n"
echo -e "###############################################################\e[0m\n"
START1="$(date +%s.%4N)"
make alpamon SGX=1
SPLIT1="$(date +%s.%4N)"

S1=`echo "$SPLIT1 - $START1 "| bc`
echo "Launching Enclave: ${S1}" >> log
