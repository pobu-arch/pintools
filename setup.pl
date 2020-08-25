#!/usr/bin/env perl
use v5.10;
use strict;
use warnings;
use File::Find;
use File::Copy;
use lib "$ENV{'VERONICA'}/perl";
use Veronica::Common;

our $THIS_DIR  = Veronica::Common::get_script_path();
our $LINUX_DIR = $THIS_DIR.'/linux_pin_3.15';
our $MACOS_DIR = $THIS_DIR.'/macos_pin_3.15';
our $PINTOOL_NAME = 'champsim';

&init();
&setup();

####################################################################################################

####################################################################################################

sub init
{
    Veronica::Common::say_level("\n", 0);
    Veronica::Common::say_level("================================", 0);
    Veronica::Common::say_level("\n", 0);
    Veronica::Common::say_level("Pin tools v0.1 by YSARCH", 0);
    Veronica::Common::say_level("\n", 0);
    Veronica::Common::say_level("================================", 0);
    Veronica::Common::say_level("\n", 0);
}

sub setup
{
    my $SRC_DIR      = $THIS_DIR."/$PINTOOL_NAME";
    my $PIN_DIR      = '';
    my $TARGET_DIR   = '';

    my $os_type = Veronica::Common::get_os_type();
    if($os_type eq 'MacOSX')
    {
        $PIN_DIR = $MACOS_DIR;
    }
    else
    {
        $PIN_DIR = $LINUX_DIR;
    }
    $TARGET_DIR .= $PIN_DIR.'/source/tools/'."$PINTOOL_NAME";
    
    system "rm -irf $TARGET_DIR" if -e $TARGET_DIR;
    system "cp -r $SRC_DIR $TARGET_DIR";

    Veronica::Common::say_level("error happened during copying $PINTOOL_NAME", -1) if !-e $TARGET_DIR;

    chdir $TARGET_DIR;
    my $fail = system "make";
    chdir $THIS_DIR;
    
    Veronica::Common::say_level("error happened during compiling $PINTOOL_NAME", -1) if $fail;
    
    Veronica::Common::override_symbol_link("$TARGET_DIR/obj-intel64/$PINTOOL_NAME.so", "$THIS_DIR/$PINTOOL_NAME.so");
    Veronica::Common::override_symbol_link("$PIN_DIR/pin", "$THIS_DIR/pin");
}