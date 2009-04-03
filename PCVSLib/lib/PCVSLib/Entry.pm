#*************************************************************************
#
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
# 
# Copyright 2008,2009 by Sun Microsystems, Inc.
#
# PCVSLib - a perl CVS client library
#
# This file is part of PCVSLib.
#
# PCVSLib is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3
# only, as published by the Free Software Foundation.
#
# PCVSLib is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License version 3 for more details
# (a copy is included in the LICENSE file that accompanied this code).
#
# You should have received a copy of the GNU Lesser General Public License
# version 3 along with PCVSLib.  If not, see
# <http://www.gnu.org/licenses/lgpl-3.0.html> for a copy of the 
# LGPLv3 License.
#
#*************************************************************************


#
# Entry.pm - package for manipulating Entry objects
#

package PCVSLib::Entry;

use Carp;
use Time::Local;

use PCVSLib::Time;

use strict;
use warnings;

#### ctor ####

sub new
{
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $entry_string = shift;
    my $self = {};
    $self->{is_directory} = 0;
    $self->{name}         = undef;
    $self->{version}      = undef;
    $self->{is_merge}     = 0;
    $self->{is_conflict}  = 0;
    $self->{options}      = undef;
    $self->{tag}          = undef;
    $self->{timestamp}    = undef; 
    $self->{to_server}    = 0;      # is entry intended to be send to server?
    $self->{is_resolved}  = 0;

    # private members
    $self->{cached_string_} = undef;
    bless ($self, $class);

    if ( defined($entry_string) ) {
        $self->parse_entry_string($entry_string);
        $self->{cached_string_} = $entry_string;
    }
    return $self;
}

#### instance accessors #####

for my $datum qw(is_directory name version is_merge is_conflict options tag timestamp to_server is_resolved) {
    no strict "refs";
    *$datum = sub {
        my $self = shift;
        if ( @_ ) {
            $self->{$datum} = shift;
            # invalidate cached string
            $self->{cached_string_} = undef;
        }
        return $self->{$datum};
    }
}

#### public methods ####

sub to_string
{
    my $self                 = shift;

    if ( defined($self->{cached_string_}) ) {
        return $self->{cached_string_};
    }
    else {
        my $name = $self->{name};
        croak("PCVSLib::to_string(): internal error: missing name") if !defined($name);
        if ( $self->{is_directory} ) {
            return "D/$name////";
        }
        else {
            my $version = $self->{version};
            if ( !$version ) {
                croak("PCVSLib::to_string(): internal error: missing implementation");
            }
            my $conflict;
            if ( $self->{to_server} ) {
                # The conflict field of the entry string has a slightly different format 
                # if send to the server or is written to an admin file. 
                if ( $self->is_conflict() ) {
                    if ( $self->{is_resolved} ) {
                        $conflict = '+';
                    }
                    else {
                        $conflict = '+=';
                    }
                }
                else {
                    $conflict = '';
                }
            }
            else {
                if ( $version eq '0' || $version =~ /^\-/) {
                    $conflict = 'dummy timestamp';
                }
                elsif ( $self->{is_merge} && $self->{is_conflict}) {
                    $conflict = 'Result of merge+' . PCVSLib::Time::seconds_to_timestr($self->timestamp);
                }
                elsif ( $self->{is_merge} ) {
                        $conflict = 'Result of merge';
                }
                else {
                    $conflict = PCVSLib::Time::seconds_to_timestr($self->timestamp);
                }
            }
            my $options = $self->{options} ? $self->{options} : '';
            my $tag = $self->{tag} ? "T" . $self->{tag} : '';
            
            return "/$name/$version/$conflict/$options/$tag";
        }
    }
}

sub is_binary 
{
    my $self = shift;
    if ( $self->{options} && $self->{options} =~ /-kb/ ) {
	    return 1;
    }
    return 0;
}
    
#### private methods ####

sub parse_entry_string
{
    my $self         = shift;
    my $entry_string = shift;

    my @items = split('/', $entry_string);
    if ( $items[0] eq 'D' ) {
        $self->{is_directory} = 1;
        $self->{name} = $items[1];
    }
    else {
        $self->{name}     = $items[1];
        $self->{version}  = $items[2];
        $self->{options}  = $items[4];
    }

    # check the 'conflict' field
    if ( $items[3] ) {
        if ( $items[3] eq "+=" ) {
            $self->{is_merge} = 1;
            $self->{is_conflict} = 1;
        }
        elsif ( $items[3] =~ /^Result of merge$/ ) {
            $self->{is_merge} = 1;
        }
        elsif ( $items[3] =~ /^Result of merge\+(.*)$/ ) {
            $self->{is_merge} = 1;
            $self->{is_conflict} = 1;
            $self->{timestamp} = PCVSLib::Time::timestr_to_seconds($1);
        }
        elsif ( $items[3] =~ /^dummy timestamp$/ ) {
        }
        else {
            $self->{timestamp} = PCVSLib::Time::timestr_to_seconds($items[3]);
            if ( !$self->{timestamp} ) {
                croak("PCVSLIB::Entry::parse_entry_string(): invalid entry string: '$entry_string'");
            }
        } 
    }

    if ( $items[4] ) {
        $self->{options} = $items[4];
    }
    if ( $items[5] ) {
        if ( $items[5] =~ /^T(.*)/ ) {
            $self->{tag} = $1;
        }
        elsif ( $items[5] =~ /^D(.*)/ ) {
            $self->{timestamp} = $self->timestr_to_seconds($1);
        }
        else {
            croak("PCVSLIB::Entry::parse_entry_string(): invalid entry string: '$entry_string'");
        }
    }
}

1;
# vim: set ts=4 shiftwidth=4 expandtab syntax=perl:
