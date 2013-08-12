Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3HLHiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:38:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40631 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754084Ab3HLHiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:38:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/lwsTnhw/JMlJ3G4LIEX/i
Date: Mon, 12 Aug 2013 00:37:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
        benoit.cousson@linaro.org, Jiri Kosina <jkosina@suse.cz>,
        Belisko Marek <marek.belisko@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@osdl.org>,
        b-cousson@ti.com, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2] N900: add device tree
Message-ID: <20130812073756.GF7656@atomide.com>
References: <20130704203256.GB27374@blackmetal.musicnaut.iki.fi>
 <20130713121709.GC16473@amd.pavel.ucw.cz>
 <20130714222819.GB3296@blackmetal.musicnaut.iki.fi>
 <20130728134409.GB5382@amd.pavel.ucw.cz>
 <20130801234355.GA15611@amd.pavel.ucw.cz>
 <20130810110955.GA11437@amd.pavel.ucw.cz>
 <CAAfyv34w1e+sAuB==-+Pj2gOO1auVNQgawcNC1Z4QfeqchRh3g@mail.gmail.com>
 <alpine.LNX.2.00.1308102226220.32627@pobox.suse.cz>
 <CAAwP0s3uNQ0Mp_QDdPuu4ThQW+cT3F6x62gkU1ku9fWUAtXLHg@mail.gmail.com>
 <20130811134751.GA5858@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130811134751.GA5858@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [130811 06:54]:
> Hi!
> 
> > >> [I wonder if this is clean-enough cause for "trivial in resubmit
> > >> mode?]
> > >
> > > On Sat, 10 Aug 2013, Belisko Marek wrote:
> > >
> > >> Same for gta04 (omap3 based device) [1].
> > >> It was send upstream 2 times and second time there is no reply from 1.3.2013.
> > >
> > > Hi guys,
> > >
> > > once I am able to match signoffs in the patches to MAINTAINERS, I can take
> > > those through trivial.git in "re-transmission mode" (or feeeding those
> > > thgough akpm si an option as well).
> > >
> > > Please just send the patches to me in a new thread properly with all the
> > > Acks/Signoffs, and mark those appropriately (i.e. maintainer that would
> > > normally push this upstream desurfaced).
> > 
> > I noticed that you are using Benoit older emails address
> > (b-cousson@ti.com) which no longer exists instead of his new email
> > address (benoit.cousson@linaro.org). So, it may be possible that
> > Benoit have not even been getting your patches.
> 
> Thanks for update.
> 
> > I'll send a patch to MAINTAINERS updating Benoit's email address so
> > get_maintainer.pl will stop lying.
> 
> Thanks!
> 
> Benoit, could you take a look at the patch from this thread? I can
> resend it, but it should be in pretty much _all_ the webmail archives
> now :-).

Hopefully Benoit will be back online after vacation soon :)

Regaqrds,

Tony
