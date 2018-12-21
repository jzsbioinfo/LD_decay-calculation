#!/bin/sh

for i in `cat file`
do

/usr/share/plink_linux_x86_64_20181202/plink --file ${i} --allow-extra-chr --indep-pairwise 50 5 0.95 --out ${i}505095

cp ${i}505095.prune.in ${i}505095.prune.in.del

./del_scaffolds.sh ${i}505095.prune.in ${i}505095.prune.in.del

/usr/share/plink_linux_x86_64_20181202/plink --file ${i} --extract ${i}505095.prune.in.del --make-bed --out ${i}505095 --allow-extra-chr

/usr/share/plink_linux_x86_64_20181202/plink --allow-extra-chr --bfile ${i}505095 --allow-no-sex --maf 0.5 --geno 0.01 --r2 --ld-window-kb 500 --ld-window 500000 --ld-window-r2 0 --out ${i}505095

cat kin_sichuan505095.ld | grep -v 'CHR_A' | awk '{print ($5-$2) "\t" $7}' | sort -n -k 1 > kin_sichuan505095.ld.sort

python compress_ld.py kin_sichuan505095.ld.sort kin_sichuan505095.ld.sort.cp

done