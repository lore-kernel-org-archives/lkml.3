Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaGPIAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:00:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34357 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaGPIAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:00:49 -0400
Date: Wed, 16 Jul 2014 10:00:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jenny Tc <jenny.tc@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Sebastian Reichel <sre@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Belisko Marek <marek.belisko@gmail.com>
Subject: Re: Power Supply Subsystem Maintainer
Message-ID: <20140716080046.GA17155@amd.pavel.ucw.cz>
References: <20140630111640.GA13774@jenny-desktop>
 <CAAfyv376J=oayov74bWdDmd+kDCwLJWAw5SMYRZGwbNP6rmEbA@mail.gmail.com>
 <20140702031119.GA385@jenny-desktop>
 <20140707112000.028524371bb7e234fcf79205@linux-foundation.org>
 <CALT56yPehFRfZu-PpPR9UeJV9b9f6azVa3QouAzwY726x-v=+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALT56yPehFRfZu-PpPR9UeJV9b9f6azVa3QouAzwY726x-v=+g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-07-12 21:21:35, Dmitry Eremin-Solenikov wrote:
> Hello,
> 
> On Mon, Jul 7, 2014 at 10:20 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 2 Jul 2014 08:41:19 +0530 Jenny Tc <jenny.tc@intel.com> wrote:
> >
> >> Andrew Morton,
> >>
> >> Appreciate your help to sort out the power supply maintainer issue. The
> >> subsystem is not active after February 2014. No response from maintainer and the
> >> last commit on git://git.infradead.org/battery-2.6 was on 2014-02-01. Appreciate
> >> your help.
> >
> > Well, two weeks ago Dmitry did say that he'd been busy at work and
> > planned to pick things up again soon.
> >
> > Dmitry, could you please make a firm and realistic decision one way or
> > the other?  If it isn't truly going to happen then that's OK - these
> > things happen.  But please tell us so other arrangements can be put in
> > place if that's the way we'll be proceeding.
> 
> Well, I am sorry. I promised that I will have time for this, but it
> seems things did not go
> the way I expected. Sebastian volunteered  to pick up power/reset
> maintainership,
> so if he still is willing to work on that topic, I'll ack a patch
> transferring maintainership
> to him.

I believe that is good idea. Does Sebastian want to submit patch to
the MAINTAINERS file?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
