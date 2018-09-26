#!/bin/bash
chips_cli=/home/xrobesx/chips3/src/chips-cli
bitcoin_cli=bitcoin-cli
gamecredits_cli=/home/xrobesx/gamecredits/src/gamecredits-cli
komodo_cli=/home/xrobesx/komodo/src/komodo-cli
hush_cli=/home/xrobesx/hush/src/hush-cli
einsteinium_cli=/home/xrobesx/einsteinium/src/einsteinium-cli

utxo_min=50
utxo_max=75

# Here we trying to split only (!) KMD

declare -a kmd_coins=(KMD)
for i in "${kmd_coins[@]}"
do
    echo -n [$i] 
    utxo=$($komodo_cli listunspent | grep .0001 | wc -l)
    echo -n ' '$utxo
    if [ $utxo -eq 0 ]; then
	echo " Need funds!"
    else
	    if [ $utxo -lt $utxo_min ]; then
	        need=$(($utxo_max-$utxo))
		echo ' now --> need '$need
		# /home/xrobesx/SuperNET/iguana/acsplit $i $need
		echo "Making $need $i UTXO's..."
		curl --url "http://127.0.0.1:7776" --data "{\"coin\":\""${i}"\",\"agent\":\"iguana\",\"method\":\"splitfunds\",\"satoshis\":\"10000\",\"sendflag\":1,\"duplicates\":"${need}"}"
	    else
		echo "$i spliting not necessary."
	    fi
    fi
done
