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
# PathName.pm - package for encapsulating 'pathnames'. Many Responses return
#               a pathname, see the cvs client documentation for details
#

package PCVSLib::PathName;

use strict;
use warnings;

#### ctor ####

sub new
{
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = {};

    $self->{local_directory} = undef;
    $self->{repository}      = undef;
    $self->{name}            = undef;

    bless ($self, $class);
    return $self;
}

#### instance accessors #####

for my $datum ('local_directory', 'repository', 'name') {
    no strict "refs";
    *$datum = sub {
        my $self = shift;
        $self->{$datum} = shift if @_;
        return $self->{$datum};
    }
}

# conveniance method
sub local_path
{
    my $self = shift;
    my $dir  = $self->{local_directory};
    my $name = $self->{name};

    if ( !defined($dir) || !defined($name) ) {
        croak("PCVSLib::PathName::local_path(): path_name not set");
    }
    else {
        return "$dir/$name";
    }
}

#### public methods ####

1;
# vim: set ts=4 shiftwidth=4 expandtab syntax=perl:
