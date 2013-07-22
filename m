Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab3GVQYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:24:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33027 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3GVQYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:24:41 -0400
Date: Mon, 22 Jul 2013 09:24:34 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Barry Song <Baohua.Song@csr.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jingchang Lu <b35083@freescale.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v4 00/17] 64-bit friendly generic sched_clock()
Message-ID: <20130722162434.GB19639@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
 <CACRpkdauSuk9xDSzUFN=OO0yVWZXSMTUuYTVDZb2_zYb=YMW_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdauSuk9xDSzUFN=OO0yVWZXSMTUuYTVDZb2_zYb=YMW_A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20, Linus Walleij wrote:
> On Fri, Jul 19, 2013 at 1:21 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> 
> > This patchset adds support for 64 bit counters in the generic
> > sched_clock code and converts drivers over to use it. Based
> > on v3.11-rc1.
> >
> > Changes since v3:
> 
> >   ocksource: dbx500-prcmu: Switch to sched_clock_register()
> 
> Fix subject.
> 
> >   clocksource: nomadik: Switch to sched_clock_register()
> 
> Apart from that Acked-by: Linus Walleij <linus.walleij@linaro.org>
> for these two drivers.
> 
> BTW: why are you not patching arch/arm/mach-u300/timer.c?
> Please make sure to grep for all setup_sched_clock() if you're
> going to do this.

Thanks.

I'll convert the arch/arm users once this series is accepted into
the tip tree. Then send off the rest through the arm-soc tree.


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
