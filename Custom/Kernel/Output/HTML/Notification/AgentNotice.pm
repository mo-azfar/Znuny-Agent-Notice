# --
# Copyright (C) 2024 mo-azfar, https://github.com/mo-azfar
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::AgentNotice;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Group',
    'Kernel::System::Log',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check paremeter
    NEEDED:
    for my $Needed (qw(Text Group)) {

        next NEEDED if defined $Param{Config}->{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "AgentNotice: Need $Needed!"
        );
        return;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    my $Output          = '';
    my $ShowAgentNotice = 0;

    # only show notice based on define frontend action
    NOTICE:
    for my $Action ( @{ $Param{Config}->{Action} } ) {
        next NOTICE if $LayoutObject->{Action} ne $Action;

        $ShowAgentNotice = 1;
        last NOTICE;
    }
    return $Output if !$ShowAgentNotice;

    # only show notice based on define group
    my $HasPermission = $GroupObject->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => $Param{Config}->{Group},
        Type      => 'rw',
    );
    return $Output if !$HasPermission;

    my $Text = $LayoutObject->{LanguageObject}->Translate("$Param{Config}->{Text}");

    $Output = $LayoutObject->Notify(
        Priority => 'Notice',
        Link     => "$Param{Config}->{URL}",
        Data     => $Text,
    );

    return $Output;

}

1;
