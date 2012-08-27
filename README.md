PCVSLib version 0.90
====================

PCVSLib is a pure perl implementation of the CVS client protocol. 

It currently supports a subset of of the specified requests 
and responses. Most notably, the "add" request for adding 
untracked files to the repository is still missing.

PCVSLib was part of the OpenOffice.org CWS tools back in the
day when the project used CVS for version control.

INSTALLATION
------------

To install this module type the following:

<pre>
perl Makefile.PL
make
make test
make install
</pre>

DEPENDENCIES
------------

This module requires these other modules and libraries:

* nothing which is not included in perl-5.6 or later,
* a cvs command line client is needed for running the
  test suite.

COPYRIGHT AND LICENCE
---------------------

<pre>
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
</pre>
