Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbaFWUPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:15:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53212 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:15:06 -0400
Date: Mon, 23 Jun 2014 22:15:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
Message-ID: <20140623201503.GA4551@amd.pavel.ucw.cz>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
 <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
 <20140621194538.GA4903@kroah.com>
 <CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
 <20140623130259.GA29809@amd.pavel.ucw.cz>
 <CAKb7UvhmatCtu2rEHgVOjitN1gAPTsgfaUmA2iOLX2Qwhi+Yxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7UvhmatCtu2rEHgVOjitN1gAPTsgfaUmA2iOLX2Qwhi+Yxg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> >> > I guess better interface would be something like
> >> >> >
> >> >> > pstate/07/core_clock_min
> >> >> >           core_clock_max
> >> >> >           memory_clock_min
> >> >> >           memory_clock_max
> >> >> >
> >> >> > and then pstate/active containing just the number of active state?
> >
> >> Could we just say that the format of this file is one-per-line of
> >>
> >> level: information-for-the-user
> >
> > But it is not.
> 
> But it is...
> 
> > Management tools will want to parse it, sooner or
> > later.  What is wrong with solution described above?
> 
> It is complex and annoying to the people that will actually use it.

grep -r . pstate/ is actually not that bad...

And yes, some kind of utility to select right performance level would
be nice in future... Or maybe not. Perhaps in not so distant future
kernel will use right performance level for given load...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
