Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbbASVgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:36:25 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57757 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbASVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:36:22 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ErewvXvJcwXaxDHM3ig5k
Date: Mon, 19 Jan 2015 13:32:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Santosh <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 0/2] ARM: l2c: OMAP4/AM437x: Additional register
 programming support.
Message-ID: <20150119213252.GJ18552@atomide.com>
References: <1420219072-6521-1-git-send-email-nm@ti.com>
 <20150102173859.GE3298@atomide.com>
 <54A6DAE8.90609@ti.com>
 <20150119212808.GI18552@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119212808.GI18552@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [150119 13:35]:
> * Nishanth Menon <nm@ti.com> [150102 09:55]:
> > On 01/02/2015 11:38 AM, Tony Lindgren wrote:
> > > * Nishanth Menon <nm@ti.com> [150102 09:20]:
> > >> Hi,
> > >>
> > >> OMAP4 and AM437x ROM code provides services to program PL310's latency
> > >> registers and AM437x provides service for programming Address filter
> > >> registers.
> > >>
> > >> Provide support in the kernel for the same.
> > >>
> > >> This provides some support to the series: http://marc.info/?l=linux-arm-kernel&m=141933190912495&w=2
> > > 
> > > Are these to be applied before Thomasz's series as fixes? If we
> > > don't need these as fixes for the -rc, then probably makes sense
> > > for RMK to merge them all together for v3.20.
> > > 
> > These dont need to go in fixes. Can easily wait till 3.20. Thomaz
> > series wont exercise these path by default until someone modifies the
> > DT properties. Yes, will be nice to have them along with other changes
> > in v3.20. just for the record, i made a couple of typos in v1 of this
> > series and have updated a retested v2 of the series.
> 
> Applying both int omap-for-v3.20/fixes thanks.

Oops actually not applying based on reading the comments in v2
of this series. Please repost if you still want to patch something.

Regards,

Tony
