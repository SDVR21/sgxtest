#!/usr/bin/env bash

set -e
GRAMINE=gramine-sgx
REQUEST=gramine-sgx-ias-request
VERIFY=gramine-sgx-ias-verify-report

# === Quoting alpamon enclave ===
echo -e "\n\e[0;33m###############################################################"
echo -e "\nExecuting Alpamon with Gramine in SGX mode . . .\n"
echo -e "###############################################################\e[0m\n"
START2="$(date +%s.%4N)"
$GRAMINE alpamon scripts/sgx-quote.py
SPLIT2="$(date +%s.%4N)"

S2=`echo "$SPLIT2 - $START2 "| bc`
echo "Quoting Enclave: ${S2}" >> log
