# LD_decay-calculation
a simple pipeline to calculate LD_decay
## this is  a readme in Chinese version
## pipeline to calculate LD decay
## last edited on 18.21.21 by Zhisheng

## plink路径
/usr/share/plink_linux_x86_64_20181202/plink

## 从VCF文件中保留个体
vcftools --vcf 8indv_Kin_het05_27Nov2018.vcf --keep keepsichuan.txt --out 4kin_sichuan.vcf

## 将scaffold_id 另外保存到一个文件中，接下来分析的都是用这些id对应的variants
cat ../vcffile/4kin_sichuan.vcf.recode.vcf | grep -v '#' | cut -f 1 | awk '{print $0 "\t" $0}' > 8kinscid.txt

## 可选步骤，删除少于1000个 variants的scaffold
#但是由于input文件一般很大（1G）,如果不是对很多群体分别计算LD,可以pruning之后再做这步
#如果不清楚我在说什么就忽略这步  
cp input output  
./del_scaffolds.sh input output

## 3.将VCF文件转换成plink格式 .ped和.map文件，其中--chrom-map 的输入时第二步的输出
vcftools --vcf ../vcffile/8indv_Kin_het05_27Nov2018.vcf --plink --chrom-map 8kinscid.txt --out 8indv_Kin

## 进行pruning
## --indep-pairwise : 可以使用SNPs个数作为窗口，也可以使用kb,使用kb步长设置为1
/usr/share/plink_linux_x86_64_20181202/plink --file test3  --allow-extra-chr --indep-pairwise 50 5 0.5 --out
/usr/share/plink_linux_x86_64_20181202/plink --file test3  --allow-extra-chr --indep-pairwise 1 kb 1 0.5 --out

## pruning之后删除variants数目少的scaffolds
#这步时间很长，可能6h
cp plink.prune.in plink.prune.in.del
./del_scaffolds.sh plink.prune.in plink.prune.in.del

## pruning之后的文件转换成bed,bim,fam
/usr/share/plink_linux_x86_64_20181202/plink --file test3 --extract plink.prune.in.del --make-bed --out prunedtest3data --allow-extra-chr

## 使用bed,bim,fam文件输入，计算ld decay
#--maf (minor allele frequency)
#--geno (SNP missing rate)
/usr/share/plink_linux_x86_64_20181202/plink --allow-extra-chr --bfile prunedtest3data --allow-no-sex --maf 0.5 --geno 0.01 --r2 --ld-window-kb 500 --ld-window 500000 --ld-window-r2 0 --out test3ld_out

## 将输出的ld文件输出成只有距离和r2两列的格式，并且排序
cat test1216pruneddata.ld | grep -v 'CHR_A' | awk '{print ($5-$2) "\t" $7}' | sort -n -k 1 > test1216pruneddata.ld.sort

## 以100nt为间隔，将每100nt以内的r2计算平均，便于作图
python compress_ld.py test1216pruneddata.ld.sort test1216pruneddata.ld.sort.cp
