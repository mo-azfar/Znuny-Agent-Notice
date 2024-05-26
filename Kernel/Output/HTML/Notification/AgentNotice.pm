# --
# Copyright (C) 2024 mo-azfar, https://github.com/mo-azfar/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::AgentNotice;

use parent 'Kernel::Output::HTML::Base';
use Kernel::System::VariableCheck qw(IsInteger);

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Group',
    'Kernel::System::Log',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = '';
    my $Action = $LayoutObject->{Action} || 0;
    my @ShowNotice;

    return $Output if !$Action;

    KEYS:
    for my $Key ( sort keys %{ $Param{Config} } ) {
        next KEYS if !IsInteger($Key);
        next KEYS if $Param{Config}->{$Key}->{Action} ne $Action;

        # check another needed paremeter
        # still allow another valid setiing execution
        NEEDED:
        for my $Needed (qw(Group Text)) {
            next NEEDED if $Param{Config}->{$Key}->{$Needed};

            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed for AgentNotice($Key)!"
            );
            next KEYS;
        }

        push @ShowNotice, $Key;
    }

    return $Output if !@ShowNotice;

    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    NOTICE:
    for my $KeyNotice (@ShowNotice) {
        my $Group = $Param{Config}->{$KeyNotice}->{Group};
        my $Text  = $Param{Config}->{$KeyNotice}->{Text};
        my $URL   = $Param{Config}->{$KeyNotice}->{URL};

        # only show notice based on define group
        my $HasPermission = $GroupObject->PermissionCheck(
            UserID    => $Self->{UserID},
            GroupName => $Group,
            Type      => 'rw',
        );

        next NOTICE if !$HasPermission;

        my $Data;

        if ( !defined($URL) || $URL eq '' ) {
            $Data = $Text;
        }
        else {
            $Data = qq~ <a href="$URL" target="_blank">$Text</a> ~;
        }

        $Output .= $LayoutObject->Notify(
            Priority => 'Notice',
            Data     => $Data,
        );
    }

    return $Output;

}

1;
