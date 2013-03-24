Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3CXJ1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 05:27:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36646 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3CXJ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 05:27:36 -0400
Date: Sun, 24 Mar 2013 10:27:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        kernel list <linux-kernel@vger.kernel.org>, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: 3.9-rc3+: reports battery as 0 mWh capacity on thinkpad x60
Message-ID: <20130324092733.GA3071@amd.pavel.ucw.cz>
References: <20130323114011.GA11092@amd.pavel.ucw.cz>
 <87zjxu9spk.fsf@nemi.mork.no>
 <20130323202155.GC18732@amd.pavel.ucw.cz>
 <6726347.ehkcE9iAxU@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6726347.ehkcE9iAxU@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >> pavel@amd:~$ cat /proc/acpi/battery/BAT0/info 
> > > >> present:                 yes
> > > >> design capacity:         0 mWh
> > > >> last full capacity:      0 mWh
> > > >> battery technology:      rechargeable
> > > >> design voltage:          14400 mV
> > > >> 
> > > >> This worked before... at least it works in 2.6 kernel used by debian.
> > > >
> > > > This works for me in 3.9-rc3.  May I see your .config?
...
> > But problem is not in /proc, /sys has zeros, too.
> > 
> > pavel@amd:~$ cat /sys/class/power_supply/BAT0/energy_full
> > 0
> > pavel@amd:~$ cat /sys/class/power_supply/BAT0/energy_full_design 
> > 0
> > pavel@amd:~$ cat /sys/class/power_supply/BAT0/model_name 
> > 93P5030
> > pavel@amd:~$
> 
> Can you narrow the time frame when it stopped working a bit?

Well, 2.6.32 from debian works ok, and self-compiled 3.1+ kernel also
seems to work ok.

I'm not sure if 3.7+ kernels worked, actually... I'd have to do some
compiling to check.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
