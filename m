Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3B0WA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:00:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:60129 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3B0WA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:00:58 -0500
Date: Wed, 27 Feb 2013 23:00:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, john.stultz@linaro.org,
        viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 0/4] time: dynamic irq affinity
In-Reply-To: <20130227104701.GZ17833@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1302272243340.22263@ionos>
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org> <512DA0EB.5000803@ti.com> <20130227104701.GZ17833@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013, Russell King - ARM Linux wrote:

> On Wed, Feb 27, 2013 at 11:30:11AM +0530, Santosh Shilimkar wrote:
> > P.S: Time and again it proves that making the local timer wakeup
> > capable solves the issue.
> 
> Slightly different take: it proves that hardware people don't talk to
> software people about what they require to make an operating system
> work.  Hardware people think they understand that and go off and do
> their own thing, and expect software people to sort out their mess.
> 
> This happens all the time; there is no solution for it as long as
> companies view the creation of hardware as being entirely separate
> from software.

Amen!

We have seen the mess this kind of thinking creates on x86 already 10+
years ago and we are still suffering.

As I said before, I really can't understand that ARM and the ARM SoC
vendors insisted to repeat the same mistakes, which we kernel people
have proven to be fatal already. It's even worse: they asked me what
problems they should avoid before they went to implement them.

I can halfways understand the little kid who insists to burn his hand
on the hot oven instead of listening to parental advice, but this kind
of advisory resistance is either caused by abuse of secrect drugs or
by living in a disconnected universe or both.

Thanks,

	tglx
