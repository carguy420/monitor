#!/bin/bash
chips_cli=/home/xrobesx/chips3/src/chips-cli
bitcoin_cli=bitcoin-cli
gamecredits_cli=/home/xrobesx/gamecredits/src/gamecredits-cli
komodo_cli=/home/xrobesx/komodo/src/komodo-cli
hush_cli=/home/xrobesx/hush/src/hush-cli
einsteinium_cli=/home/xrobesx/einsteinium/src/einsteinium-cli

utxo_min=75
utxo_max=75

# Here we trying to split only (!) BTC

declare -a kmd_coins=(BTC)
for i in "${kmd_coins[@]}"
do
    echo -n [$i] 
    utxo=$($bitcoin_cli listunspent | grep .0001 | wc -l)
    echo -n ' '$utxo
    if [ $utxo -eq 0 ]; then
	echo " Need funds!"
    else
	    if [ $utxo -lt $utxo_min ]; then
	        need=$(($utxo_max-$utxo))
		echo ' --> '$need
		# /home/xrobesx/SuperNET/iguana/acsplit $i $need
		echo "Do you wish to split $i?"
		select yn in "Yes" "No"; do
		    case $yn in
			Yes ) curl --url "http://127.0.0.1:7776" --data "{\"coin\":\""${i}"\",\"agent\":\"iguana\",\"method\":\"splitfunds\",\"satoshis\":\"10000\",\"sendflag\":1,\"duplicates\":"${need}"}"; break;;
			No ) break;;
		    esac
		done
	    else
		echo
	    fi
    fi
done
