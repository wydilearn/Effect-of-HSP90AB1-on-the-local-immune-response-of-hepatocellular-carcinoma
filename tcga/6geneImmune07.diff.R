#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("limma")

#install.packages("ggplot2")
#install.packages("ggpubr")


#引用包
library(limma)
library(ggplot2)
library(ggpubr)
expFile="symbol.txt"     #表达输入文件
gene="VCAN"              #基因的名称
setwd("C:\\Users\\lexb4\\Desktop\\geneImmune\\07.diff")     #设置工作目录

#读取基因表达文件,并对数据进行处理
rt=read.table(expFile, header=T, sep="\t", check.names=F)
rt=as.matrix(rt)
rownames(rt)=rt[,1]
exp=rt[,2:ncol(rt)]
dimnames=list(rownames(exp),colnames(exp))
data=matrix(as.numeric(as.matrix(exp)), nrow=nrow(exp), dimnames=dimnames)
data=avereps(data)
data=t(data[gene,,drop=F])

#正常和肿瘤数目
group=sapply(strsplit(rownames(data),"\\-"), "[", 4)
group=sapply(strsplit(group,""), "[", 1)
group=gsub("2", "1", group)
conNum=length(group[group==1])       #正常组样品数目
treatNum=length(group[group==0])     #肿瘤组样品数目
Type=c(rep(1,conNum), rep(2,treatNum))

#差异分析
exp=cbind(data, Type)
exp=as.data.frame(exp)
colnames(exp)=c("gene", "Type")
exp$Type=ifelse(exp$Type==1, "Normal", "Tumor")
exp$gene=log2(exp$gene+1)

#设置比较组
group=levels(factor(exp$Type))
exp$Type=factor(exp$Type, levels=group)
comp=combn(group,2)
my_comparisons=list()
for(i in 1:ncol(comp)){my_comparisons[[i]]<-comp[,i]}

#绘制boxplot
boxplot=ggboxplot(exp, x="Type", y="gene", color="Type",
		          xlab="",
		          ylab=paste0(gene, " expression"),
		          legend.title="Type",
		          palette = c("blue","red"),
		          add = "jitter")+ 
	stat_compare_means(comparisons=my_comparisons,symnum.args=list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns")),label = "p.signif")

#输出图片
pdf(file=paste0(gene,".diff.pdf"), width=5, height=4.5)
print(boxplot)
dev.off()


######生信自学网: https://www.biowolf.cn/
######课程链接1: https://shop119322454.taobao.com
######课程链接2: https://ke.biowolf.cn
######课程链接3: https://ke.biowolf.cn/mobile
######光俊老师邮箱：seqbio@foxmail.com
######光俊老师微信: eduBio
