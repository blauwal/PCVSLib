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

use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'PCVSLib',
    VERSION_FROM      => 'lib/PCVSLib.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/PCVSLib.pm', # retrieve abstract from module
       AUTHOR         => 'Jens-Heiner Rechtien<jens-heiner.rechtien@sun.com>') : ()),
);
# vim: set ts=4 shiftwidth=4 expandtab syntax=perl:
