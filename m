Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3HLHhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:37:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39371 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754231Ab3HLHhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:37:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19lYogmyktwH0GTTYwtOBCa
Date: Mon, 12 Aug 2013 00:36:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Belisko Marek <marek.belisko@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@osdl.org>,
        b-cousson@ti.com, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2] N900: add device tree
Message-ID: <20130812073654.GE7656@atomide.com>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1308102226220.32627@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Kosina <jkosina@suse.cz> [130810 13:36]:
> On Sat, 10 Aug 2013, Pavel Machek wrote:
> 
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

Sorry for the delays, I think Benoit is still on vacation. Plus the
non-functioning email address issue certainly does not help..

Anyways, let's just let Benoit queue these to avoid pointless merge
conflicts with the .dts files as discussed several times earlier.

Regards,

Tony
