Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab3GSAXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 20:23:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34663 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3GSAXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 20:23:17 -0400
Date: Thu, 18 Jul 2013 17:23:15 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Barry Song <Baohua.Song@csr.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Jingchang Lu <b35083@freescale.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Christopher Covington <cov@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/17] 64-bit friendly generic sched_clock()
Message-ID: <20130719002315.GF27430@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
 <51E88170.3080505@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E88170.3080505@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18, John Stultz wrote:
> On 07/18/2013 04:21 PM, Stephen Boyd wrote:
> >This patchset adds support for 64 bit counters in the generic
> >sched_clock code and converts drivers over to use it. Based
> >on v3.11-rc1.
> >
> >Changes since v3:
> >  * Move to use seqcount to fix issues with 64-bit cyc counters
> >  * Move to hrtimer to fix underflow/overflow errors in wraparound
> >    calculation
> >  * Use of 1 hour in clocks_calc_mult_shift
> >  * Converted over drivers in drivers/clocksource
> 
> I've not been able to take a deep review yet, but this looks pretty
> much like what we discussed last week, so I'm happy with it so far.
> Has this gotten much testing (on both 32 and 64bit systems?)

I've tested it on a couple 32 bit systems. I'll ask around for
some 64 bit system testing.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
