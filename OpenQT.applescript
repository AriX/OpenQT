tell application "System Events"
	set appName to the name of the first process whose frontmost is true
end tell

set videoLinkJS to "document.getElementsByTagName('video')[0].src"
set videoTimestampJS to "document.getElementsByTagName('video')[0].currentTime"

if appName is "Safari" then
	tell application "Safari"
		set frontmostTab to the current tab of the first window
		tell frontmostTab
			set frontmostTitle to the name
			set videoLink to do JavaScript videoLinkJS
			set videoTimestamp to do JavaScript videoTimestampJS
		end tell
	end tell
else if appName is "Google Chrome" then
	tell application "Google Chrome"
		set frontmostTab to the active tab of the first window
		tell frontmostTab
			set frontmostTitle to the title
			set videoLink to execute javascript videoLinkJS
			set videoTimestamp to execute javascript videoTimestampJS
		end tell
	end tell
else
	set videoLink to missing value
	set frontmostTitle to missing value
end if

if videoLink is not missing value then
	tell application "QuickTime Player"
		set numberOfVideosPlaying to the number of documents
		open URL videoLink
		-- Wait until QuickTime has opened the video
		repeat with i from 1 to 60
			if the number of documents is (numberOfVideosPlaying + 1) then exit repeat
			delay 0.05
		end repeat
		set the current time of document 1 to videoTimestamp
	end tell
else
	if frontmostTitle is not missing value then
		display dialog "Could not find a video playing in \"" & frontmostTitle & "\"." with icon caution
	end if
end if
