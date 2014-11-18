Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaKRSfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:35:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40336 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaKRSfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:35:48 -0500
Date: Tue, 18 Nov 2014 19:35:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, bcousson@baylibre.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141118183545.GA16999@amd>
References: <20141116075928.GA9763@amd>
 <20141117101553.GA21151@amd>
 <20141117145545.GC7046@atomide.com>
 <201411171601.32311@pali>
 <20141117150617.GD7046@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141117150617.GD7046@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-11-17 07:06:17, Tony Lindgren wrote:
> * Pali Rohár <pali.rohar@gmail.com> [141117 07:03]:
> > On Monday 17 November 2014 15:55:46 Tony Lindgren wrote:
> > > 
> > > There's nothing stopping us from initializing the camera code
> > > from pdata-quirks.c for now to keep it working. Certainly the
> > > binding should be added to the driver, but that removes a
> > > dependency to the legacy booting mode if things are otherwise
> > > working.
> > 
> > Tony, legacy board code for n900 is not in mainline tree. And 
> > that omap3 camera subsystem for n900 is broken since 3.5 
> > kernel... (both Front and Back camera on n900 show only green 
> > picture).
> 
> I'm still seeing the legacy board code for n900 in mainline tree :)
> It's deprecated, but still there.
> 
> Are you maybe talking about some other piece of platform_data that's
> no longer in the mainline kernel?
> 
> No idea what might be wrong with the camera though.

Camera support for main and secondary cameras was never mainline, AFAICT.

Merging it will not be easy, as it lacks DT support... and was broken
for long time.

Anyway, flash is kind of important for me, since it makes phone useful
as backup light; and it is simple piece of hw, so I intend to keep it
useful.

       	       	   	    	      	      	  		     Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
