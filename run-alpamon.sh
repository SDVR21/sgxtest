#!/usr/bin/env bash

set -e
GRAMINE=gramine-sgx
REQUEST=gramine-sgx-ias-request
VERIFY=gramine-sgx-ias-verify-report
# if test -n "$SGX"
# then
#     GRAMINE=gramine-sgx
# else
#     GRAMINE=gramine-direct
# fi

# === make alpacon & alpamon ===
make clean > /dev/null
echo -e "\n\e[0;33m###############################################################"
echo -e "\nLaunching Alpamon enclave . . .\n"
echo -e "###############################################################\e[0m\n"
START1="$(date +%s.%4N)"
make alpamon SGX=1
SPLIT1="$(date +%s.%4N)"

# === Quoting alpamon enclave ===
echo -e "\n\e[0;33m###############################################################"
echo -e "\nExecuting Alpamon with Gramine in SGX mode . . .\n"
echo -e "###############################################################\e[0m\n"
START2="$(date +%s.%4N)"
$GRAMINE alpamon scripts/sgx-quote.py
SPLIT2="$(date +%s.%4N)"

S1=`echo "$SPLIT1 - $START1 "| bc`
S2=`echo "$SPLIT2 - $START2 "| bc`
echo "Launching Enclave: ${S1}" >> log
echo "Quoting Enclave: ${S2}" >> log
