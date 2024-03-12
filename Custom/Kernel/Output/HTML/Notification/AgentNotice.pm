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

use Kernel::Language qw(Translatable);
use Kernel::System::DateTime;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
	
	#get paremeter
	my %GetParam;
    for my $Needed ( qw( Text Group) )
	{
       if ( !$Param{Config}->{$Needed} ) 
	   {
			$LogObject->Log(
				Priority => 'error',
				Message  => "AgentNotice: Need $Needed!"
			);
        	
			return;
	   }
	}

	my $Output = '';
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
	
	my $ShowAgentNotice = 0;
    NOTICE:
	
	#only show notice based on define frontend action
	for (@{$Param{Config}->{Action}})
	{
        next if $LayoutObject->{Action} ne $_;
		
		if ( $LayoutObject->{Action} eq $_ ) {
            $ShowAgentNotice = 1;
            last NOTICE;
        }
	}
	
	#only show notice based on define group
	my $HasPermission = $GroupObject->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => $Param{Config}->{Group},
        Type      => 'rw',
    );	
	
	if ( $ShowAgentNotice && $HasPermission )
	{
		$Output = $LayoutObject->Notify(
			Priority => 'Notice',
			Link     => "$Param{Config}->{URL}",
			Data => $LayoutObject->{LanguageObject}->Translate(
                   "$Param{Config}->{Text}"
            ),
		);
	}
	
	return $Output;
	
}

1;
