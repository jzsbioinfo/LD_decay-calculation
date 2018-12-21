#!/bin/sh
# -*- coding: utf-8 -*-
#there are 899 scaffolds for this case, the number need to be changed according to your data
for (( i=899;i>=1;i-- ));
do

num=$(cat $1 | grep "HiC_scaffold_$i" | wc -l);

if [ $num -le 1000 ]; then
sed -i "/^HiC_scaffold_$i/d" $2;
fi
echo $num
done
