Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3HKAzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 20:55:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55460 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3HKAzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 20:55:15 -0400
Date: Sun, 11 Aug 2013 02:55:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Belisko Marek <marek.belisko@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@osdl.org>,
        Tony Lindgren <tony@atomide.com>, b-cousson@ti.com,
        pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: OMAP device tree maintainance (was Re: [PATCH v2] N900: add device
 tree)
Message-ID: <20130811005507.GA29513@amd.pavel.ucw.cz>
References: <20130704171939.GA27374@blackmetal.musicnaut.iki.fi>
 <20130704202145.GB10752@amd.pavel.ucw.cz>
 <20130704203256.GB27374@blackmetal.musicnaut.iki.fi>
 <20130713121709.GC16473@amd.pavel.ucw.cz>
 <20130714222819.GB3296@blackmetal.musicnaut.iki.fi>
 <20130728134409.GB5382@amd.pavel.ucw.cz>
 <20130801234355.GA15611@amd.pavel.ucw.cz>
 <20130810110955.GA11437@amd.pavel.ucw.cz>
 <CAAfyv34w1e+sAuB==-+Pj2gOO1auVNQgawcNC1Z4QfeqchRh3g@mail.gmail.com>
 <alpine.LNX.2.00.1308102226220.32627@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1308102226220.32627@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > [I wonder if this is clean-enough cause for "trivial in resubmit
> > mode?]
> 
> On Sat, 10 Aug 2013, Belisko Marek wrote:
> 
> > Same for gta04 (omap3 based device) [1].
> > It was send upstream 2 times and second time there is no reply from 1.3.2013.
> 
> Hi guys,
> 
> once I am able to match signoffs in the patches to MAINTAINERS, I can take 
> those through trivial.git in "re-transmission mode" (or feeeding those 
> thgough akpm si an option as well).
> 
> Please just send the patches to me in a new thread properly with all the 
> Acks/Signoffs, and mark those appropriately (i.e. maintainer that would 
> normally push this upstream desurfaced).

Mail sent (just to you, to keep mail volume down).

I noticed two non-delivery reports in my INBOX; seems Benoit
disappeared rather permanently:

...
If you do so, please include this problem report. You can
delete your own text from the attached returned message.
 
                   The mail system
 
<b-cousson@ti.com>: host cluster5.us.messagelabs.com[216.82.250.99]
said: 550   
    Invalid recipient <b-cousson@ti.com> (#5.1.1) (in reply to RCPT TO
    command)
 

...so maybe MAINTAINERS file will need fixing?

OMAP DEVICE TREE SUPPORT
M:      Benoît Cousson <b-cousson@ti.com>
M:      Tony Lindgren <tony@atomide.com>
L:      linux-omap@vger.kernel.org
L:      devicetree@vger.kernel.org
S:      Maintained
F:      arch/arm/boot/dts/*omap*
F:      arch/arm/boot/dts/*am3*

:-(. Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
