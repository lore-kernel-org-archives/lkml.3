Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3EGUNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:13:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57175 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3EGUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:13:44 -0400
Date: Tue, 7 May 2013 22:13:39 +0200
From: Pavel Machek <pavel@denx.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, tglx@linutronix.de,
        Jamie Iles <jamie@jamieiles.com>, dinguyen@altera.com, wd@denx.de,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Message-ID: <20130507201339.GB8169@amd.pavel.ucw.cz>
References: <20130426121433.GA16249@amd.pavel.ucw.cz>
 <201305061545.22587.arnd@arndb.de>
 <20130506155304.GA6645@amd.pavel.ucw.cz>
 <201305062324.17080.arnd@arndb.de>
 <20130507135752.GA3500@amd.pavel.ucw.cz>
 <51892E5E.8090909@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51892E5E.8090909@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>>So I guess it should go through the timekeeping tree...?
> >>I would prefer that, but we can also take it through arm-soc, it doesn't
> >>really matter.
> >I see no response from timekeeping people... so if you could take it,
> >that would be great.
> 
> I don't think the original patch ever made it to my inbox.

Aha, so for 3.8, 

pavel@amd:/data/l/linux-n900$ scripts/get_maintainer.pl -f
drivers/clocksource/dw_apb_timer.c
John Stultz <johnstul@us.ibm.com> (supporter:TIMEKEEPING, NTP)
Thomas Gleixner <tglx@linutronix.de> (supporter:TIMEKEEPING, NTP)
linux-kernel@vger.kernel.org (open list)

for 3.9, it works ok.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
