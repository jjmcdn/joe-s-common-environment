--
-- TODO
--  - break the mail filtering function into smaller sub-functions
--
--  - figure out how LUA handles arrays so I don't have, for example, six lines
--    of contain_subject() when I really just want contain_subject(X||Y||Z).
--
--  - instead of moving messages between mailboxes, keep most of them in the
--    inbox and add extra header tags (a la procmail) so I can have mutt filter
--    and colour them differently based on those header tags.  Think poor-man's
--    gmail labels.
--

---------------
--  Options  --
---------------

options.timeout = 120
options.info = true
options.subscribe = true

----------------
--  Accounts  --
----------------

-- WR
wrs = IMAP {
	server = 'imap-na.wrs.com',
	username = 'corp/UNIX_USERNAME/MAIL.NAME',
	password = 'UNIX_PASSWORD',
	ssl = "ssl3",
}

function proc_inbox()
	-- turf out linux-mods noise
	msgs = wrs.INBOX:contain_to('linux-mods@windriver.com')
	wrs.INBOX:move_messages(wrs['Project/commitlogs'], msgs)

	-- Move the CQ crap to an appropriate place
	msgs = wrs.INBOX:contain_from('clearquest-admin@windriver.com') + 
	       wrs.INBOX:contain_from('clearquest-inbox@windriver.com')
	wrs.INBOX:move_messages(wrs['Project/Fall08/cq-noise'], msgs)

	-- Grab anything where anyone talks about CGL and move it somewhere special.
	-- See how that works.
	msgs = ( wrs.INBOX:contain_body('carrier') +
		 wrs.INBOX:contain_body('Carrier') +
		 wrs.INBOX:contain_body(' CGL') +
		 wrs.INBOX:contain_body(' cgl') +
		 wrs.INBOX:contain_body('_cgl') +
		 wrs.INBOX:contain_subject('[eng-linuxprod-cgl]') ) -
	       ( wrs.INBOX:contain_to('macdona') +
		 wrs.INBOX:contain_cc('macdona') )
	wrs.INBOX:move_messages(wrs['Project/Networking'], msgs)

	-- Move the CGL, SCOPE and SAF stuff to the appropriate places
	msgs = wrs.INBOX:contain_field('List-id', 'lf_carrier.lists.linux-foundation.org')
	wrs.INBOX:move_messages(wrs['Partner Interaction/CGL'], msgs)
	msgs = wrs.INBOX:contain_field('List-id', 'users.list.opensaf.org') +
	       wrs.INBOX:contain_field('List-id', 'bod.list.opensaf.org') +
	       wrs.INBOX:contain_field('List-id', 'openais.lists.linux-foundation.org') +
	       wrs.INBOX:contain_field('List-id', 'openipmi-developer.lists.sourceforge.net') +
	       wrs.INBOX:contain_field('List-id', 'tlc.list.opensaf.org')
	wrs.INBOX:move_messages(wrs['Partner Interaction/SAF'], msgs)
	msgs = wrs.INBOX:contain_subject('[scope-cgos]') +
	       wrs.INBOX:contain_subject('[scope-members]')
	wrs.INBOX:move_messages(wrs['Partner Interaction/SCOPE'], msgs)

	-- And ship all the review requests that aren't to me off elsewhere
	msgs = ( wrs.INBOX:contain_subject('Fix WIND00') +
		 wrs.INBOX:contain_subject('Review Request') +
		 wrs.INBOX:contain_subject('RevReq') +
		 wrs.INBOX:contain_subject('Review request') ) -
	       ( wrs.INBOX:contain_to('macdona') +
		 wrs.INBOX:contain_cc('macdona') )
	wrs.INBOX:move_messages(wrs['Project/Fall08/reviews'], msgs)

	-- Also, dump all the remaining non-work-but-still-internal lists
	-- somewhere for later processing.
	msgs = ( wrs.INBOX:contain_subject('[linux-embedded]') +
		 wrs.INBOX:contain_subject('[linux-cockpit]') +
		 wrs.INBOX:contain_subject('[techfield]') +
		 wrs.INBOX:contain_subject('[geek-field]') +
		 wrs.INBOX:contain_subject('[eng-lpg-osc]') +
		 wrs.INBOX:contain_subject('[linux-eng]') +
		 wrs.INBOX:contain_to('eng-lpg-bsp@windriver.com') ) -
	       ( wrs.INBOX:contain_to('macdona') +
		 wrs.INBOX:contain_cc('macdona') )
	wrs.INBOX:move_messages(wrs['wrlists'], msgs)
end

-- I had to disable daemon_mode because when it was running constantly in the
-- background it tended to close the mailbox on mutt, which in turn caused mutt
-- to segfault on me (!) if imapfilter happened to wake up while mutt was
-- suspended and gvim was running (which happens, as expected, when I'm
-- composing a mail).  This was irritating, to say the least, so now I invoke
-- imapfilter by hand periodically and look through my list of new messages and
-- mail boxes.
--
-- I really would like to turn daemon_mode back on, but I like being able to
-- compose mail more than I like having it automatically filtered for me.  That,
-- and I'm sure there's just some other setting I've turned on (or failed to
-- turn on) that will save me, I just haven't had time to RTFM.
--
--daemon_mode(120, proc_inbox)
proc_inbox()
