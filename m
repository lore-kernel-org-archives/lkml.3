Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3GTUvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 16:51:12 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:51871 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab3GTUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 16:51:10 -0400
MIME-Version: 1.0
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Date: Sat, 20 Jul 2013 22:51:09 +0200
Message-ID: <CACRpkdauSuk9xDSzUFN=OO0yVWZXSMTUuYTVDZb2_zYb=YMW_A@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] 64-bit friendly generic sched_clock()
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 1:21 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> This patchset adds support for 64 bit counters in the generic
> sched_clock code and converts drivers over to use it. Based
> on v3.11-rc1.
>
> Changes since v3:

>   ocksource: dbx500-prcmu: Switch to sched_clock_register()

Fix subject.

>   clocksource: nomadik: Switch to sched_clock_register()

Apart from that Acked-by: Linus Walleij <linus.walleij@linaro.org>
for these two drivers.

BTW: why are you not patching arch/arm/mach-u300/timer.c?
Please make sure to grep for all setup_sched_clock() if you're
going to do this.

Yours,
Linus Walleij
