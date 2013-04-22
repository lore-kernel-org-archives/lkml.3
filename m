Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3DVPwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:52:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63283 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab3DVPwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:52:13 -0400
Date: Mon, 22 Apr 2013 16:51:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/4] ARM 64 bit sched_clock take #2
Message-ID: <20130422155147.GA7018@e106331-lin.cambridge.arm.com>
References: <51709FD7.8050408@gmail.com>
 <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
 <20130422153408.GD3791@e106331-lin.cambridge.arm.com>
 <517558EE.5020708@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517558EE.5020708@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 04:36:14PM +0100, Stephen Boyd wrote:
> On 04/22/13 08:34, Mark Rutland wrote:
> > Hi Stephen,
> >
> > On Sat, Apr 20, 2013 at 01:29:02AM +0100, Stephen Boyd wrote:
> >> This is what I was thinking. I don't see why we can't move this to generic
> >> code and have arm64 use it too. Those patches will follow once I find an
> >> arm64 compiler.
> >>
> >> First two patches should probably go in even if the 64 bit stuff doesn't go in
> >> at the same time.
> >>
> >> Stephen Boyd (4):
> >>   ARM: sched_clock: Remove unused needs_suspend member
> >>   ARM: sched_clock: Return suspended count earlier
> >>   ARM: sched_clock: Add support for >32 bit sched_clock
> >>   ARM: arch_timer: Move to setup_sched_clock_64()
> >>
> >>  arch/arm/include/asm/sched_clock.h |   5 +-
> >>  arch/arm/kernel/arch_timer.c       |  14 +----
> >>  arch/arm/kernel/sched_clock.c      | 111 ++++++++++++++++++++++++++-----------
> >>  3 files changed, 84 insertions(+), 46 deletions(-)
> > I wanted to look at the series with more context, but I don't seem to be able
> > to apply patch 2 and beyond to my tree, and I couldn't figure out what tree
> > this series was based on.
> >
> > What do I need to use as the base for this series?
> 
> These are based on next-20130419.

Cheers!

Mark.
