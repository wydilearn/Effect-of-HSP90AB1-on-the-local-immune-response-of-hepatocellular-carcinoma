###Video source: http://study.163.com/provider/1026136977/index.htm?share=2&shareId=1026136977
######Video source: http://www.biowolf.cn/shop/
######生信自学网: http://www.biowolf.cn/
######合作邮箱：2749657388@qq.com
######答疑微信: 18520221056
use strict;
use warnings;

my %hash=();

open(RF,"gene.txt") or die $!;
while(my $line=<RF>){
	chomp($line);
	$line=~s/^\s+|\s+$//g;
	$hash{$line}=1;
}
close(RF);

###Video source: http://study.163.com/provider/1026136977/index.htm?share=2&shareId=1026136977
######Video source: http://www.biowolf.cn/shop/
######生信自学网: http://www.biowolf.cn/
######合作邮箱：2749657388@qq.com
######答疑微信: 18520221056

my @indexs=();

open(RF,"survivalInput.txt") or die $!;
open(WF,">lassoInput.txt") or die $!;
while(my $line=<RF>){
	my @arr=split(/\t/,$line);
	if($.==1){
		print WF "$arr[0]\t$arr[1]\t$arr[2]";
		for(my $i=1;$i<=$#arr;$i++){
			if(exists $hash{$arr[$i]}){
				push(@indexs,$i);
				print WF "\t$arr[$i]";
			}
		}
		print WF "\n";
	}
	else{
		print WF "$arr[0]\t$arr[1]\t$arr[2]";
		foreach my $geneIndex(@indexs){
			print WF "\t$arr[$geneIndex]";
		}
		print WF "\n";
	}
}
close(WF);
close(RF);

###Video source: http://study.163.com/provider/1026136977/index.htm?share=2&shareId=1026136977
######Video source: http://www.biowolf.cn/shop/
######生信自学网: http://www.biowolf.cn/
######合作邮箱：2749657388@qq.com
######答疑微信: 18520221056