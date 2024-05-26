# Znuny Agent Notice

- Display simple notice in agent portal

1. Go to Admin > System Configuration > Frontend::NotifyModule###880-AgentNotice

		1 =>    Action - define which screen to show the agent notice.  
			Group - only show the notice to specific rw group.  
			Text -  text to display. Mandatory.  
			URL - to display the text as URL Hyperlink. Optional.  
	
	Example,
	
		1 =>    Action = AgentTicketZoom
			Group = admin
			Text = hellllooo
			URL = www.google.com
			
		2 =>    Action = AgentDashboard
			Group = admin
			Text = BYEEEEEE
			
			
![agent_notice](doc/en/images/agent_notice.png)