Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaHYIAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:00:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbaHYIAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:00:19 -0400
Date: Mon, 25 Aug 2014 03:00:18 -0500 (CDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Hawkes <hawkes@google.com>
Subject: Re: [PATCH 1/2] HID: logitech-dj: prevent false errors to be shown
In-Reply-To: <20140825075552.GA298@x4>
Message-ID: <alpine.LNX.2.00.1408250300030.23162@pobox.suse.cz>
References: <1408738566-6805-1-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1408250249150.23162@pobox.suse.cz> <20140825075552.GA298@x4>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014, Markus Trippelsdorf wrote:

> > > Commit "HID: logitech: perform bounds checking on device_id early
> > > enough" unfortunately leaks some errors to dmesg which are not real
> > > ones:
> > > - if the report is not a DJ one, then there is not point in checking
> > >   the device_id
> > > - the receiver (index 0) can also receive some notifications which
> > >   can be safely ignored given the current implementation
> > > 
> > > Move out the test regarding the report_id and also discards
> > > printing errors when the receiver got notified.
> > > 
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > 
> > I have now queued this one for 3.17. Adding Markus to CC -- Markus, this 
> > should make the spurious error messages you have reported go away.
> 
> Indeed it does. Feel free to add:
> 
> Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>

Excellent, thanks. Will be pushing it to Linus this week.

-- 
Jiri Kosina
SUSE Labs
