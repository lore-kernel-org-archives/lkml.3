Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3EFPxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:53:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43106 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3EFPxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:53:09 -0400
Date: Mon, 6 May 2013 17:53:04 +0200
From: Pavel Machek <pavel@denx.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>, dinguyen@altera.com, wd@denx.de,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        johnstul@us.ibm.com, tglx@linutronix.de,
        kernel list <linux-kernel@vger.kernel.org>, john.stultz@linaro.org
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Message-ID: <20130506155304.GA6645@amd.pavel.ucw.cz>
References: <20130426121433.GA16249@amd.pavel.ucw.cz>
 <20130426214313.GB24891@amd.pavel.ucw.cz>
 <20130506124814.GA28259@amd.pavel.ucw.cz>
 <201305061545.22587.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305061545.22587.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-05-06 15:45:22, Arnd Bergmann wrote:
> On Monday 06 May 2013, Pavel Machek wrote:
> > 
> > Hi!
> > 
> > Ping? Previous version was tested by Dinh, and this one is based on
> > Jamie's updates, so I assume it is acceptable for him, too.
> > 
> > It brings two platforms closer together, and makes time actually work
> > on socfpga. It would be good to get it applied.
> 
> Who should apply it? I guess it needs to go through arm-soc with all the
> other clocksource changes already queued up there. Can we have an Ack
> from Jamie and from the clocksource maintainers?

Well, changes to arch/arm/mach-picoxcell are single line (and that's a
cleanup of duplicate include). 

So I guess it should go through the timekeeping tree...?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
