Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032AbaALNPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 08:15:11 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34872 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaALNPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 08:15:08 -0500
Date: Sun, 12 Jan 2014 14:15:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] Timekeeping changes for 3.14
Message-ID: <20140112131505.GA16132@gmail.com>
References: <52C5E6A0.7010507@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C5E6A0.7010507@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> Hey Thomas,
>   Hope you're having a good new years! Here's my current timekeeping
> queue for 3.14.
> 
> This includes a number of changes I had earlier proposed for 3.13, but
> decided to defer due to it being so late in the 3.13 cycle.
> 
> The only two items not previously posted are:
>    tick/timekeeping: Call update_wall_time outside the jiffies lock
>    timekeeping: Remove comment that's mostly out of date
> 
> I'll send the entire queue in reply to this mail.
> 
> Please take a look and let me know if you have any objections.
> 
> thanks
> -john
> 
> 
> The following changes since commit 0e6601eee039893a3f6420596ae4588d90d13cbe:
> 
>   Merge branch 'timers/posix-timers-for-tip-v2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks
> into timers/core (2013-12-10 12:32:36 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.linaro.org/people/john.stultz/linux.git fortglx/3.14/time
> 
> for you to fetch changes up to 38aef31ce7773624c8f09ff58c4c27b3b955faaf:
> 
>   timekeeping: Remove comment that's mostly out of date (2013-12-23
> 12:53:22 -0800)
> 
> ----------------------------------------------------------------
> Borislav Petkov (1):
>       rtc-cmos: Add an alarm disable quirk
> 
> John Stultz (7):
>       timekeeping: Fix lost updates to tai adjustment
>       timekeeping: Fix potential lost pv notification of time change
>       timekeeping: Avoid possible deadlock from clock_was_set_delayed
>       tick/timekeeping: Call update_wall_time outside the jiffies lock
>       timekeeping: Fix CLOCK_TAI timer/nanosleep delays
>       timekeeping: Fix missing timekeeping_update in suspend path
>       timekeeping: Remove comment that's mostly out of date
> 
> Yijing Wang (1):
>       timekeeper: fix comment typo for tk_setup_internals()
> 
>  drivers/rtc/rtc-cmos.c      | 52
> +++++++++++++++++++++++++++++++++++++++++++-
>  kernel/time/tick-common.c   |  1 +
>  kernel/time/tick-internal.h |  1 +
>  kernel/time/tick-sched.c    |  1 +
>  kernel/time/timekeeping.c   | 53
> ++++++++++++++++++++++-----------------------
>  5 files changed, 80 insertions(+), 28 deletions(-)

Pulled into tip:timers/core, thanks John!

	Ingo
