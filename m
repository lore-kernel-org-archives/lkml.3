Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab3IAWMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:12:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46618 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3IAWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:12:14 -0400
Date: Mon, 2 Sep 2013 00:12:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org
Subject: Re: 3.11-final plan: unpriviledged user can crash the kernel
 (using bluetooth rfcomm)
Message-ID: <20130901221212.GA15595@amd.pavel.ucw.cz>
References: <20130831100127.GA6711@amd.pavel.ucw.cz>
 <20130831100933.GA7029@amd.pavel.ucw.cz>
 <20130831101451.GC7029@amd.pavel.ucw.cz>
 <20130831104238.GA7767@amd.pavel.ucw.cz>
 <20130901165525.GK7440@joana>
 <20130901185038.GA11714@amd.pavel.ucw.cz>
 <B3715CDF-1D85-45C9-9AD1-DBBD0DF24624@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B3715CDF-1D85-45C9-9AD1-DBBD0DF24624@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>>>> . Python sources for client/server are at 
> >>>>>> 
> >>>>>> http://tui.cvs.sourceforge.net/viewvc/tui/tui/liveview/
> >>>>>> 

> > So... In 3.11 unpriviledged user can crash the kernel, but the fix is
> > too big, so we release it without the fix?
> > 
> > Somehow, I don't think that's good idea.
> 
> can you boot a bluetooth-next kernel and see if the planned changes are fixing this or not. I would like to have that confirmed before we start any speculations here.
> 
> If the RFCOMM TTY rework that we have in bluetooth-next fixes this issue, then we can have a look at if this can be patched for 3.11 or a stable kernel without having to include the whole patch series. Or if the TTY subsystem changed from 2.6.32 so much that we have to take the whole changes.
> 
> However, please also note there is a different between RFCOMM sockets and RFCOMM TTYs. I would be curious if only the TTY part is affected or also the socket part.
> 

Well, you are in as good position to repeat it as I am. Sources are in
the CVS referenced above (and they are trivial). The version that
reproduces the problem is marked as such in changelog. I already
modified my system to work (not triggering oopsen)...

Yes, I can probably setup linux-next. It will take some time.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
