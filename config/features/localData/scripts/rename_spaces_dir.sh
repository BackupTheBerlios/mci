#!/usr/bin/perl
opendir(CUR,".")|| die "can't open .";
while($filename=readdir(CUR)){
	$file=$filename;
	$filename=~tr/ /_/d;
	if($file != ".") {
		rename($file,$filename) || warn "can't rename $file";
	}
}
