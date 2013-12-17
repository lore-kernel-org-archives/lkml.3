Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3LQXIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:08:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55333 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3LQXIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:08:48 -0500
Date: Wed, 18 Dec 2013 00:08:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system
 suspend/hibernation
Message-ID: <20131217230843.GA2911@amd.pavel.ucw.cz>
References: <201201281445.49377.rjw@sisk.pl>
 <201202172159.15396.rjw@sisk.pl>
 <CA+5PVA50UA1oP1jKgnQjHh8APp=cNWREw3bkfrkV1OW_Tg1g+A@mail.gmail.com>
 <201205252113.50900.rjw@sisk.pl>
 <CA+5PVA5GWsTdNky-K1-hu5_R55hdKfr-Oa26HpX=FdA1cRZsbQ@mail.gmail.com>
 <CA+5PVA7vsZPd9eXwN-Q+d8c9+0bAmVdr698vv+LFyrn+3iFOMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7vsZPd9eXwN-Q+d8c9+0bAmVdr698vv+LFyrn+3iFOMA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> Did this patch ever wind up going anywhere?  Fedora has it sitting in
> >>> our tree with a comment that says "rebase" and I don't see it in the
> >>> linux-next tree at all.
> >>>
> >>> Did if fall through the cracks or was it NAKed somewhere?
> >>
> >> No, it wasn't in principle. There were some comments I haven't addressed yet.
> >
> > Dredging up a really old thread, sorry.
> >
> > We're still carrying this patch along in Fedora.  Should we drop it at
> > this point, or is it still eventually going to head upstream?

I'd say drop.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
