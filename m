Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaJ1Sue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:50:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44175 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaJ1Sub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:50:31 -0400
Date: Tue, 28 Oct 2014 19:50:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: suspend to partition Re: A desktop environment[1] kernel wishlist
Message-ID: <20141028185028.GA13410@amd>
References: <1413881397.30379.7.camel@hadess.net>
 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
 <1413911644.30379.12.camel@hadess.net>
 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
 <1413914978.30379.14.camel@hadess.net>
 <20141027092804.GB9807@amd>
 <1414420292.30379.55.camel@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414420292.30379.55.camel@hadess.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >   For mobile
> > > > devices this is an expected design point, but for off-the-shelf
> > > > laptops with big fans and exhaust vents, I'm not sure how safe this
> > > > would be, so you may need to constrain this functionality somehow (or
> > > > look to see if a enforced low-power resume is possible).
> > > 
> > > I think that we won't know whether it's a problem until the point that
> > > somebody actually implements it.
> > 
> > Kernel does not stop you at this point, right?
> > 
> > Suspend-to-partition is also doable today (see suspend.sf.net),
> 
> Is it perfect? Because no releases in 3 years kind of scares me.

Yes, it is perfect :-). 

[It is in use by SUSE, so it should be good; and if anything, it shows
that suspend-to-partition does not need kernel help.]

> >  or you
> > can just swapon before starting. You can take it off the list, I
> > believe.
> 
> Or we could create a new filesystem type that isn't swap, that isn't
> used by swap at all, but could be created by distributions' installers.
> Then I wouldn't need to hope that the swap didn't start being used in
> between me enabling it, and the suspend actually occurring (making it
> impossible to disable afterwards).

I see there's a race, but is it big enough to matter in practice? I
don't think so. Anyway -- suspend.sf.net is way to go for advanced
features.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
