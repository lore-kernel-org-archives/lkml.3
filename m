Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbaJ2Ver (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:34:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55387 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaJ2Vep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:34:45 -0400
Date: Wed, 29 Oct 2014 22:34:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Felipe Balbi <balbi@ti.com>,
        sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: Nokia n900 problems in 3.18-rc1 (was Re: USB Ethernet gadget on
 Nokia n900)
Message-ID: <20141029213442.GB32576@amd>
References: <201410262222.39892@pali>
 <20141026215548.GA9004@amd>
 <201410262323.17891@pali>
 <20141027195209.GP2560@atomide.com>
 <20141027223114.GU2560@atomide.com>
 <20141028220450.GA27667@amd>
 <20141028221124.GT2542@atomide.com>
 <20141029084637.GA30662@amd>
 <20141029140943.GX2542@atomide.com>
 <5450F746.4030901@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5450F746.4030901@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-10-29 16:18:46, Tomi Valkeinen wrote:
> On 29/10/14 16:09, Tony Lindgren wrote:
> 
> >> omapfb reports problems, but seems to work ok:
> >>
> >> [    0.990386] omapfb omapfb: cannot parse default modes
> >> [    1.004791] Console: switching to colour frame buffer device 100x30
> >> [    1.073150] omapfb omapfb: using display 'lcd' mode 800x480
> > 
> > Tomi, is the default mode warning correct here?
> 
> omapfb warns that it couldn't parse kernel cmdline parameters
> ('omapfb.mode' parameter). I couldn't find in the thread what actual
> parameters were used in this case.

I had omapfb.mode=lcd:848x480-16 on command line. I removed it now.

> Although I don't see why N900 would need any omapfb mode parameters in
> the first place, as the LCD has just one mode...

I don't know where I copied it from, sorry...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
