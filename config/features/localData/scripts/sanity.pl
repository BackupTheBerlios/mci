#!/usr/bin/perl -w

# Function prototypes:
sub readFiles($);
sub renameFile($$);
sub help();

##############################################################################
# rename a given File
sub renameFile($$){

	(my $path,$file) = @_;
	my $newfile = $file;
	
	#add more tranislations here:

	#$newfile =~ s/^[0-9]*-//;	
	$newfile =~ s/ /_/g;	#Spaces
	$newfile =~ s/_-_/-/g;	#Dashes should not be surounded by underscores
	$newfile =~ s/;/_/g;	#remove semicolons
	#$newfile =~ s/,/_/g;	#remove commas
	$newfile =~ s/\\//g;	#remove backspaces
	$newfile =~ s/_-/-/g;
	$newfile =~ s/-_/-/g;
	$newfile =~ s/__/_/g;   #Reduce multiple spaces to one
	
	$newfile =~ s/mp3/mp3/gi;
	$newfile =~ s/rar/rar/gi;
	$newfile =~ s/pdf/pdf/gi;
	$newfile =~ s/pdb/pdb/gi;
	$newfile =~ s/&/and/g;
	
	#German Umlauts (Linux charset)
	$newfile =~ s/ü/ue/g;
	$newfile =~ s/Ü/Ue/g;
	$newfile =~ s/ö/oe/g;
	$newfile =~ s/Ö/Oe/g;
	$newfile =~ s/ä/ae/g;
	$newfile =~ s/Ä/Ae/g;
	$newfile =~ s/ß/ss/g;

	#German Umlauts (Windows charset)
	$newfile =~ s/\x8e/Ae/g;
	$newfile =~ s/\x99/Oe/g;
	$newfile =~ s/\x9A/Ue/g;
	$newfile =~ s/\x84/ae/g;
	$newfile =~ s/\x94/oe/g;
	$newfile =~ s/\x81/ue/g;
	$newfile =~ s/\xe1/ss/g;

	#Send in hex-values of other chars (eg. danish?) and their
	#replacements: a.gohr@web.de !

	if ("$path/$file" ne "$path/$newfile"){
	  print STDERR "Renaming '$file' to '$newfile'";
	  if (-e "$path/$newfile"){
            print STDERR "\tSKIPPED new file exists\n";
	  }else{
 	    if (rename("$path/$file","$path/$newfile")){
	      print STDERR "\tOKAY\n";
	    }else{
	      print STDERR "\tFAILED\n";
	    }
          }
	}
}

##############################################################################
# Read a given directory and its subdirectories
sub readFiles($) {
  (my $path)=@_;
  
  opendir(ROOT, $path);
  my @files = readdir(ROOT);
  closedir(ROOT);

  foreach (@files) {
    next if /^\.|\.\.$/;  #skip upper dirs
    my $file =$_;
    my $fullFilename    = "$path/$file";
    
    
    if (-d $fullFilename) {
      readFiles($fullFilename); #Recursion
    }
    
    renameFile($path,$file); #Rename

  }
}

##############################################################################
# prints a short Help text
sub help() {
print STDERR <<STOP

      Syntax: sanity.pl <files-dir>

      files-dir   All files in this directory and below will be sanitized

      This tool will rename files with spaces or german Umlauts back to sane
      names, for making it easyier to download them via ftp. It scans the
      start-directory recursively!

      If a renamed version of a file already exists the renaming will be
      skipped.
      _____________________________________________________________________
      sanity.pl - Sanitize Filenames
      Copyright (C) 2001 Andreas Gohr <a.gohr\@web.de>

      This program is free software; you can redistribute it and/or
      modify it under the terms of the GNU General Public License as
      published by the Free Software Foundation; either version 2 of
      the License, or (at your option) any later version.
      
      See COPYING for details
STOP
}

##############################################################################
# Main

if (@ARGV != 1){
  help();
  exit -1;
}

my $root = $ARGV[0];
readFiles($root);
