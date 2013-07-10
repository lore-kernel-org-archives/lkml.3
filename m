Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3GJIvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:51:19 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45765 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3GJIvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:51:18 -0400
Date: Wed, 10 Jul 2013 10:51:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>,
        Don Zickus <dzickus@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] nohz: A few updates
Message-ID: <20130710085113.GA24884@gmail.com>
References: <1371742960-24727-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371742960-24727-1-git-send-email-fweisbec@gmail.com>
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
> Note that "watchdog: Boot-disable by default on full dynticks" is a temporary
> solution to solve the issue with the watchdog that prevents the tick from
> stopping. This is to make sure that 3.11 doesn't have that problem as several
> people complained about it.
> 
> A proper and longer term solution has been proposed by Peterz:
> 
> 	http://lkml.kernel.org/r/20130618103632.GO3204@twins.programming.kicks-ass.net
> 
> I plan to work on it. But since I'll be off next week, I prefer to have
> at least a working temporary solution before the next merge window.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (4):
>       watchdog: Register / unregister watchdog kthreads on sysctl control
>       watchdog: Rename confusing state variable
>       watchdog: Boot-disable by default on full dynticks
>       nohz: Remove obsolete check for full dynticks CPUs to be RCU nocbs
> 
> Steven Rostedt (1):
>       nohz: Warn if the machine can not perform nohz_full
> 
> 
>  include/linux/nmi.h      |    2 +-
>  kernel/sysctl.c          |    4 +-
>  kernel/time/tick-sched.c |   15 ++----
>  kernel/watchdog.c        |  113 ++++++++++++++++++++++++++--------------------
>  4 files changed, 72 insertions(+), 62 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
