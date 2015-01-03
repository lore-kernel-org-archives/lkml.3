Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbbACA05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 19:26:57 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60223 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752498AbbACA0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 19:26:55 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18p5SD/DuZp4GhQ6SAj/hwz
Date: Fri, 2 Jan 2015 16:23:17 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>,
        Russell King <linux@arm.linux.org.uk>, Santosh <ssantosh@kernel.org>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH V2 0/2] ARM: l2c: OMAP4/AM437x: Additional register
 programming support.
Message-ID: <20150103002317.GH3298@atomide.com>
References: <1420220628-23742-1-git-send-email-nm@ti.com>
 <54A6E79E.7010203@oracle.com>
 <54A6F5C8.2050008@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A6F5C8.2050008@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [150102 11:50]:
> On 01/02/2015 12:46 PM, santosh.shilimkar@oracle.com wrote:
> > On 1/2/15 9:43 AM, Nishanth Menon wrote:
> >> Hi,
> >> OMAP4 and AM437x ROM code provides services to program PL310's latency
> >> registers and AM437x provides service for programming Address filter
> >> registers.
> >>
> >> Provide support in the kernel for the same.
> >>
> >> V2 of the series contains documentation update and a bug fix due to a
> >> typo introduced during patch split :(
> >>
> >> Nishanth Menon (2):
> >>    ARM: l2c: OMAP4/AM437x: Introduce support for cache latency
> >>      programming
> >>    ARM: l2c: AM437x: Introduce support for cache filter programming
> >>
> > Looks fine to me ...
> > Feel free to add my ack if you need one ...
> > 
> > Minor: The subject looks like I2C though it is L2C ;-)
> > 
> Yeah, the thought did occur to me, but decided instead to go with the
> existing $subject conventions of arch/arm/mach-omap2/omap4-common.c
> ARM: l2c: omap2+: get rid of init call
> ARM: l2c: omap2+: get rid of redundant cache replacement policy setting
> ARM: l2c: omap2: remove explicit non-secure access bits
> ARM: l2c: omap2: remove cache size override
> ARM: l2c: omap2: remove explicit SMI calls to enable L2 cache
> ARM: l2c: omap2: implement new write_sec method
> ARM: l2c: remove platforms/SoCs setting early BRESP
> ARM: l2c: fix register naming
> ARM: l2c: omap2: remove ES1.0 support
> 
> ..
> 
> If folks feel strongly about this, I can capitalize the same and post
> a v3 to help confusing fonts on certain mail clients and terminals.
> let me know if folks want me to.

I guess no need to :)

Looks like these still won't fix the issue we found in the
series posted by Tomasz though. At least I'm still getting errors
on am437x with these and the patches from Tomasz applied.

Regards,

Tony
