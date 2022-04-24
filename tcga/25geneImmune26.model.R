#install.packages("glmnet")
#install.packages("survival")
#install.packages('survminer')


#引用包
library(glmnet)
library(survival)
library(survminer)
inputFile="uniSigExp.txt"      #单因素显著基因的表达输入文件
setwd("C:\\Users\\lexb4\\Desktop\\geneImmune\\26.model")         #设置工作目录
rt=read.table(inputFile, header=T, sep="\t", row.names=1, check.names=F)    #读取输入文件

#COX模型构建
multiCox=coxph(Surv(futime, fustat) ~ ., data = rt)
multiCox=step(multiCox, direction="both")
multiCoxSum=summary(multiCox)

#输出模型相关信息
outMultiTab=data.frame()
outMultiTab=cbind(
		          coef=multiCoxSum$coefficients[,"coef"],
		          HR=multiCoxSum$conf.int[,"exp(coef)"],
		          HR.95L=multiCoxSum$conf.int[,"lower .95"],
		          HR.95H=multiCoxSum$conf.int[,"upper .95"],
		          pvalue=multiCoxSum$coefficients[,"Pr(>|z|)"])
outMultiTab=cbind(id=row.names(outMultiTab),outMultiTab)
write.table(outMultiTab, file="multiCox.txt", sep="\t", row.names=F, quote=F)

#输出风险文件
score=predict(multiCox, type="risk", newdata=rt)
coxGene=rownames(multiCoxSum$coefficients)
coxGene=gsub("`", "", coxGene)
outCol=c("futime", "fustat", coxGene)
risk=as.vector(ifelse(score>median(score), "high", "low"))
outTab=cbind(rt[,outCol], riskScore=as.vector(score), risk)
write.table(cbind(id=rownames(outTab),outTab), file="risk.txt", sep="\t", quote=F, row.names=F)

#绘制森林图
pdf(file="multi.forest.pdf", width=10, height=6, onefile=FALSE)
ggforest(multiCox,
		 data=rt,
         main = "Hazard ratio",
         cpositions = c(0.02,0.22, 0.4), 
         fontsize = 0.7, 
         refLabel = "reference", 
         noDigits = 2)
dev.off()


######生信自学网: https://www.biowolf.cn/
######课程链接1: https://shop119322454.taobao.com
######课程链接2: https://ke.biowolf.cn
######课程链接3: https://ke.biowolf.cn/mobile
######光俊老师邮箱：seqbio@foxmail.com
######光俊老师微信: eduBio
