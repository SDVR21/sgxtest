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

#Extract expected mr signer & mr enclave from alpamon sig 
MR_SIGNER=`gramine-sgx-sigstruct-view alpamon.sig | grep "mr_signer" | cut -d ":" -f2 | tr -d " "`
MR_ENCLAVE=`gramine-sgx-sigstruct-view alpamon.sig | grep "mr_enclave" | cut -d ":" -f2 | tr -d " "`

# === Sending request to IAS ===
echo -e "\n\e[0;36m###############################################################"
echo -e "\nExecuting Alpacon & Sending request to IAS . . .\n"
echo -e "###############################################################\e[0m\n"
START3="$(date +%s.%4N)"
$REQUEST report \
    --verbose --api-key=51b6e381cffe472ea2ac56dc06a14632 \
    --quote-path=alpamon.quote \
    --report-path=ias.report --sig-path=ias.sig
SPLIT3="$(date +%s.%4N)"

# === Verifying Alpamon enclave with IAS report ===
echo -e "\n\e[0;36m###############################################################"
echo -e "\nVerifying Alpamon enclave with IAS report . . .\n"
echo -e "###############################################################\e[0m\n"
START4="$(date +%s.%4N)"

$VERIFY \
    --verbose --report-path=ias.report --sig-path=ias.sig \
    --mr-signer=$MR_SIGNER \
    --mr-enclave=$MR_ENCLAVE \
    --allow-sw-hardening-needed --allow-debug-enclave 2>&1 | tee -a OUTPUT
SPLIT4="$(date +%s.%4N)"

if [[ $(grep -o "OK" OUTPUT | wc -l) -eq 3 ]]; then
    echo -e "\e[0;32m\n###############################################################\n"
    echo -e "[ Alpamon RA success ]\n\e[0m"
    F=1
else
    echo -e "\e[0;31m\n###############################################################\n"
    echo -e "[ Alpamon RA failed ]\n\e[0m"
    F=0
fi
rm OUTPUT

S3=`echo "$SPLIT3 - $START3 "| bc`
S4=`echo "$SPLIT4 - $START4 "| bc`
# echo -e "Requesting report to IAS: 0${S4}"
# echo -e "Verifying IAS report: 0${S5}"
echo "Requesting report to IAS: 0${S3}" >> log
echo "Verifying IAS report: 0${S4}" >> log
cat log

total=$(grep -oP '\d+\.\d+' log | awk '{sum += $1} END {print sum}')
echo ""
echo "Total ra time: $total"

if [ ${F} -eq 1 ] ; then
    echo -e "\e[0;32m\n###############################################################\n\e[0m"
else
    echo -e "\e[0;31m\n###############################################################\n\e[0m"
fi
