Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaENMjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:39:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaENMjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:39:24 -0400
Date: Wed, 14 May 2014 14:39:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc: regression in suspend
In-Reply-To: <20140513214155.GA5087@amd.pavel.ucw.cz>
Message-ID: <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
References: <20140513160926.GA3621@amd.pavel.ucw.cz> <20140513163734.GA4602@amd.pavel.ucw.cz> <20140513214155.GA5087@amd.pavel.ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Pavel Machek wrote:

> > > There seems to be regression in 3.15 w.r.t. suspend to ram and suspend
> > > to disk.
> > > 
> > > Resume sometiems works, but often, system is half-usable, with "what
> > > do you want to do suspend/hibernate" dialog staying on screen.
> > > 
> > > I did echo disk > /sys/power/state, and echo never returned to the
> > > shell prompt. (X was not really working, either.)
> > > 
> > > It is still there on 3.15.0-rc3+. I'll update to rc5 now.
> > 
> > 3.15.0-rc5+ seems to behave a bit better. Lets see if it reappears.
> 
> It did. 

So it might in the end of the day the same thing as I have reported in 

	https://bugs.freedesktop.org/show_bug.cgi?id=76554

which is not 100% reproducible either (although with newer kernels it's 
*much* more reproducible for me than with older).

> It worked few times on -rc5, but then I rebooted and problem 
> re-appeared.

If you could capture dmesg of the resume where X fails to resume properly 
to see whether you have i915 ring initialization errors there as well?

-- 
Jiri Kosina
SUSE Labs

