#! /usr/bin/env python
# -*- coding: utf-8 -*-
import sys
from cStringIO import StringIO
file = open(sys.argv[1],'r')
newfile = open(sys.argv[2],'w+')
newline = []

n=1
m=0
sumd=0
sumr=0
for line in file:
	m=m+1
	dist=int(line.strip().split("\t")[0])
	r2=float(line.strip().split("\t")[1])
	if int(dist) <= n*100:
		sumd+=dist
		sumr+=r2
	elif int(dist)> n*100:
		n+=1
		
		sumr+=r2
		meand=sumd/m
		meanr=sumr/m
		
		
		newfile.write(str(meand)+"\t")
		
		newfile.write(str(meanr)+"\n")
		
		m=1
		sumd=0
		sumr=0
		sumd+=dist
		sumr+=r2

file.close()
newfile.close()


