Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3DWIkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:40:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34634 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3DWIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:40:08 -0400
Date: Tue, 23 Apr 2013 10:40:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        kernel list <linux-kernel@vger.kernel.org>, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: 3.9-rc3+: reports battery as 0 mWh capacity on thinkpad x60
Message-ID: <20130423084005.GA4269@amd.pavel.ucw.cz>
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

Ok, I'm not sure when it stopped working, but it works again in
3.9.0-rc8+. Good :-).

(And sorry for slow response).

In the meantime, I got chromium-browser disappearing on me, all at
once, before it started opening initial tabs. This is first time I
seen that, with dmesg saying:

chromium-browse[3728]: segfault at 95968e80 ip b666875e sp af5e9a20
error 4 in chromium-browser[b5e0d000+1960000]

. I hope it is just a coincidence, because otherwise 3.9 looks
usable...

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
