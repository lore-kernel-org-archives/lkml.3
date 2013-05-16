Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3EPRoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:44:03 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56158 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619Ab3EPRoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:44:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+2MWH2qsLp5OZVwkrRNVV4
Date: Thu, 16 May 2013 10:43:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Nishanth Menon <nm@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH V5 1/6] clk: OMAP: introduce device tree binding to
 kernel clock data
Message-ID: <20130516174355.GB5600@atomide.com>
References: <1368039976-29648-1-git-send-email-nm@ti.com>
 <1368039976-29648-2-git-send-email-nm@ti.com>
 <20130513235119.10068.47040@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513235119.10068.47040@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Turquette <mturquette@linaro.org> [130513 16:56]:
> Quoting Nishanth Menon (2013-05-08 12:06:11)
> <snip>
> > Overall strategy introduced here is simple: a clock node described in
> > device tree blob is used to identify the exact clock provided in the
> > SoC specific data. This is then linked back using of_clk_add_provider
> > to the device node to be accessible by of_clk_get.
> > 
> 
> FYI, I'm working on moving the OMAP clocks over to DT which is a better
> alternative than this patch.  I'll share what I have on the list,
> hopefully next week.

That's good news! What's your plan on using the indexing the clocks?

I'd rather avoid indexing as that's basically same as the old IRQ
numbering and GPIO numbering schemes that don't work well in the long
term.

We already have quite a few sets of clocks for omaps, so the indexing
is already an issue. My thinking is that indexing should only be used
if the same physical clock has multiple outputs.

Regards,

Tony
