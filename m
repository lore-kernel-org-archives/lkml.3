Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3IUMhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 08:37:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50164 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3IUMhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 08:37:34 -0400
Date: Sat, 21 Sep 2013 14:37:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Message-ID: <20130921123732.GB4652@amd.pavel.ucw.cz>
References: <201302171616.50152@pali>
 <20130907230252.GA10700@blackmetal.musicnaut.iki.fi>
 <20130918131644.GA2953@amd.pavel.ucw.cz>
 <201309181800.10486@pali>
 <20130918174211.GU9994@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918174211.GU9994@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > > --- /dev/null
> > > > > > +++ b/arch/arm/mach-omap2/board-rx51-camera.c
> > > > 
> > > > [...]
> > > > 
> > > > > Ping, can you review this patch v2?
> > > > 
> > > > I don't think Tony will accept any new board stuff for
> > > > RX-51/N900. See for example:
> > > > http://marc.info/?l=linux-kernel&m=137629626213187&w=2
> > > > 
> > > > There should be initial Nokia N900 DTS file in 3.12-rc1, and
> > > > we should continue converting this board fully to DT.
> > > 
> > > That's not reasonable. N900 is pretty far away from working
> > > with device tree. Yes, I was able to get some bits merged,
> > > but that should not be excuse to halt other N900 development.
> > > 									Pavel
> > 
> > Right. So Tony, will you accept future patches for board files?
> 
> Only fixes to board-*.c files please unless there's a _really_
> good reason to make things more complex with the platform data.
> Let's not make the DT conversion any more complex than it
> already is.
> 
> Getting things working with DT for the devices is pretty trivial
> in most cases. And we can also still initialize the legacy devices
> using platform data the same way as earlier.

Well... It was quite a struggle to get video working with device tree
in 3.10, and now it is broken in 3.12-rc1, again.

"Now, here, you see, it takes all the running you can do, to keep in
the same place. If you want to get somewhere else, you must run at
least twice as fast as that! "

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
