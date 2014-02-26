Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaBZRFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:05:47 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25045 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751131AbaBZRFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:05:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+U7HY2xAd/+ynUCEfSnkY3
Date: Wed, 26 Feb 2014 09:05:31 -0800
From: Tony Lindgren <tony@atomide.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        arm <linux-arm-kernel@lists.infradead.org>,
        omap <linux-omap@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [patch 08/26] arm: Replace various irq_desc accesses
Message-ID: <20140226170530.GC11654@atomide.com>
References: <20140223212703.511977310@linutronix.de>
 <20140223212737.099151500@linutronix.de>
 <20140224025539.GE25011@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224025539.GE25011@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shawn Guo <shawn.guo@linaro.org> [140223 18:58]:
> On Sun, Feb 23, 2014 at 09:40:12PM -0000, Thomas Gleixner wrote:
> > Use the proper functions. There is no need to fiddle with irq_desc.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> ...
> >  arch/arm/mach-imx/pm-imx6q.c        |    7 +++----
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Tony Lindgren <tony@atomide.com> 
