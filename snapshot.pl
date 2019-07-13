#!/usr/bin/perl - w
#print $ARGV[1];
sub save_master {
    opendir my $object, "./" or die;
    my @objects = readdir $object;
    closedir $object;
    #print "@dirs\n";
    my @matched_dirs;
    foreach $dir (@objects) {
        #print $dir;
        if ($dir =~ "^\.snapshot\.[0-9]+") {
           # print "found";
            $dir =~ s/\.snapshot\.//;
        push @matched_dirs, $dir;
        }
    }
    # first snapshot
    if (@matched_dirs == 0) {
        save_snapshot(0, @objects);
    } 
    # has snapshotted before
    else {
        @sorted_matched_dirs = sort { $a <=> $b } @matched_dirs;
        $snapshot_num = (pop @sorted_matched_dirs) + 1;
       # print $snapshot_num;
        save_snapshot($snapshot_num, @objects);
        #print "@sorted_matched_dirs\n";
    }
}
sub save_snapshot {
    my ($snapshot_num, @files) = @_;
    print "Creating snapshot $snapshot_num\n";
    mkdir ".snapshot.$snapshot_num";
    foreach $file (@files) {
        use File::Copy qw(copy);
        if ($file ne "snapshot.pl") {
            copy $file, "./.snapshot.$snapshot_num/$file";
        }
    }
}

sub load_snapshot {
    my ($load_num) = @_;
    save_master();
    print "Restoring snapshot $load_num\n";
   # system(pl snapshot.pl save);
    #print $load_num;
    opendir my $file, "./.snapshot.$load_num" or die;
    my @files = readdir $file;
    foreach $file (@files) {
        use File::Copy qw(copy);
       # print "Copying $file\n";
        copy ("./.snapshot\.$load_num/$file", "$file"); 
    }
    closedir $file;
} 
if ($ARGV[0] eq "save") {
    save_master();
}
elsif ($ARGV[0] eq "load") {
    $load_number = "$ARGV[1]";
    load_snapshot($load_number);
}

# check for user input is correct what if they dont give you the load number 
# does the load number exist?
# when it loads does it only update or rm if it doesnt exiset in the bckup
#it tries to copy . and ..