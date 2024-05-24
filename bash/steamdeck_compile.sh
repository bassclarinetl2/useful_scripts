#!/usr/bin/env bash

set -- $(locale LC_MESSAGES)
yesexpr="$1"; noexpr="$2"; yesword="$3"; noword="$4"

echo "This script will configure the SteamDeck to allow compiling from source"
while true; do
    read -p "Have you set a sudo password (${yesword} / ${noword})? " yn
    if [[ "$yn" =~ $yesexpr ]]; then exit; fi
    if [[ "$yn" =~ $noexpr ]]; then 
       read "Do you want me to help with that (${yesword} / ${noword})" yn
       if [[ "$yn" =~ $yesexpr ]]; then passwd; fi
       if [[ "$yn" =~ $noexpr ]]; then exit;fi
        echo "Answer ${yesword} / ${noword}."
    fi
   echo "Answer ${yesword} / ${noword}."
done


