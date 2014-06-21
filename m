Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaFUSuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 14:50:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45895 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaFUSux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 14:50:53 -0400
Date: Sat, 21 Jun 2014 20:50:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>, Greg KH <greg@kroah.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
Message-ID: <20140621185051.GA25094@amd.pavel.ucw.cz>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
 <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-06-21 14:22:59, Ilia Mirkin wrote:
> On Sat, Jun 21, 2014 at 2:02 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > AFAICT, pstate file will contain something like
> >
> > 07: core 100 MHz memory 123 MHz *
> > 08: core 100-200 MHz memory 123 MHz
> >
> > ...which does not look exactly like one-value-per-file, and I'm pretty
> > sure userspace will get it wrong if it tries to parse it. Plus, I
> > don't see required documentation in Documentation/ABI.
...
> 
> FTR, this file has been in place since 3.13, and there was a different
> file before it (performance_levels), with a comparable format since
> much earlier (definitely 3.8, probably earlier). I think it's meant
> a

According to the article, it is only starting to work now. I know
articles can be wrong, but I don't have that hardware... Sorry if it
is the case.

> lot more for people looking at it and echo'ing stuff to it to modify
> the levels (where supported), than for programs parsing it. Perhaps
> sysfs is the wrong place for this -- what is the right place? debugfs?

debugfs would work, yes.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
