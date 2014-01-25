Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaAYH2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 02:28:17 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:41218 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaAYH2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 02:28:13 -0500
Date: Sat, 25 Jan 2014 08:28:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [GIT PULL] tick: A few more cleanups
Message-ID: <20140125072810.GA8056@gmail.com>
References: <1389886912-4783-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389886912-4783-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the timers/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/core
> 
> HEAD: 8fe8ff09ce3b5750e1f3e45a1f4a81d59c7ff1f1
> 
> ----
> Nothing very exiting, just a bunch of non-critical cleanups for the next merge window:
> 
> 1) Make the IRQ tick APIs naming more symetric
> 
> 2) Optimize a bit jiffies_lock code coverage
> 
> 3) Whitespace fixes from Alex Shi
> 
> 4) Fix overflow in scheduler tick max deferment calculation. Given the
> current 1 second max limitation, this bug shouldn't happen in mainline.
> It's rather to prepare for making this value tunable. Or simply in case
> we change the current constant.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       tick: Rename tick_check_idle() to tick_irq_enter()
>       nohz: Get timekeeping max deferment outside jiffies_lock
> 
> Alex Shi (1):
>       nohz_full: fix code style issue of tick_nohz_full_stop_tick
> 
> Kevin Hilman (1):
>       sched/nohz: Fix overflow error in scheduler_tick_max_deferment()
> 
> 
>  include/linux/jiffies.h  |  6 ++++++
>  include/linux/tick.h     |  6 +++---
>  kernel/sched/core.c      |  2 +-
>  kernel/softirq.c         |  2 +-
>  kernel/time/tick-sched.c | 27 ++++++++++++++-------------
>  5 files changed, 25 insertions(+), 18 deletions(-)

Pulled, thanks Frederic!

	Ingo
