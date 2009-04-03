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
# Request.pm - packages for creating and sending Requests
#

package PCVSLib::Request;

use Carp;

use strict;
use warnings;

use PCVSLib::Response;

#### ctor ####

sub new
{
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = {};
    $self->{request_data}    = shift;
    $self->{additional_data} = shift;
    $self->{file}            = shift;
    # private members

    bless ($self, $class);

    return $self;
}

#### instance accessors #####

for my $datum qw(request_data additional_data file) {
    no strict "refs";
    *$datum = sub {
        my $self = shift;
        $self->{$datum} = shift if @_;
        return $self->{$datum};
    }
}

#### public methods ####

sub response_expected { 
    return 0; 
}

sub additional_data_attached {
    return 0;
}

sub file_attached {
    return 0;
}

#### private methods ####

package PCVSLib::VersionRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    return "version\n" 
}

package PCVSLib::ValidRequestsRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    return "valid-requests\n" 
}

package PCVSLib::ValidResponsesRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $valid_responses_str = join(" ", @{PCVSLib::Response::valid_responses()});
    return "Valid-responses $valid_responses_str\n" 
}

package PCVSLib::RootRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Root " . $self->{request_data} . "\n";
}

package PCVSLib::UseUnchangedRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    return "UseUnchanged\n" 
}

package PCVSLib::DirectoryRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

use Carp;

sub additional_data_attached
{
    my $self = shift;
    if ( !$self->{additional_data} ) {
        croak("PCVSLIB::ModifiedRequest(): additional request data missing");
    }
    return 1;
}

sub to_string 
{ 
    my $self = shift;
    return "Directory " . $self->{request_data} . "\n";
}

sub additional_data_to_string
{
    my $self = shift;

    return $self->{additional_data} . "\n";
}

package PCVSLib::ArgumentRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Argument " . $self->{request_data} . "\n";
}

package PCVSLib::ArgumentxRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Argumentx " . $self->{request_data} . "\n";
}

package PCVSLib::EntryRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Entry " . $self->{request_data}->to_string() . "\n";
}

package PCVSLib::LogRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    return "log\n";
}

package PCVSLib::StatusRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    my $self = shift;
    return "status\n";
}

package PCVSLib::RLogRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    my $self = shift;
    return "rlog\n";
}

package PCVSLib::RDiffRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    my $self = shift;
    return "rdiff\n";
}

package PCVSLib::TagRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    my $self = shift;
    return "tag\n";
}

package PCVSLib::CheckoutRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    return "co\n" 
}

package PCVSLib::ExpandModulesRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    return "expand-modules\n" 
}

package PCVSLib::UnchangedRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Unchanged " . $self->{request_data} . "\n";
}

package PCVSLib::ModifiedRequest;
use vars('@ISA');
use Carp;
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Modified " . $self->{request_data} . "\n";
}

sub file_attached
{
    return 1;
}

package PCVSLib::IsModifiedRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Is-modified " . $self->{request_data} . "\n";
}

package PCVSLib::QuestionableRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Questionable " . $self->{request_data} . "\n";
}

package PCVSLib::StaticDirectoryRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Static-directory\n";
}

package PCVSLib::StickyRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub to_string 
{ 
    my $self = shift;
    return "Sticky " . $self->{request_data} . "\n";
}

package PCVSLib::NoOpRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    return "noop\n" 
}

package PCVSLib::CiRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    my $self = shift;
    return "ci\n";
}

package PCVSLib::UpdateRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    my $self = shift;
    return "update\n";
}

package PCVSLib::RemoveRequest;
use vars('@ISA');
@ISA=('PCVSLib::Request');

sub response_expected 
{ 
    return 1; 
}

sub to_string 
{ 
    my $self = shift;
    return "remove\n";
}

1;
# vim: set ts=4 shiftwidth=4 expandtab syntax=perl:
