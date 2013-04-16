Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3DPIqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:46:20 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63960 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3DPIqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:46:17 -0400
Date: Tue, 16 Apr 2013 10:46:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] nohz: More Kconfig and Rcu improvements
Message-ID: <20130416084613.GA7480@gmail.com>
References: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the latest timers/nohz branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/nohz
> 
> HEAD: 65d798f0f9339ae2c4ebe9480e3260b33382a584
> 
> This fixes some of the issues you've reported. There is still the
> dependency on CONFIG_VIRT_CPU_ACCOUNTING_GEN to fix, probably in
> the Kconfig side. Stay tuned.
> 
> Thanks.
> 
> ---
> Frederic Weisbecker (4):
>   nohz: Fix old dynticks idle Kconfig backward compatibility
>   nohz: Switch from "extended nohz" to "full nohz" based naming
>   nohz: Align periodic tick Kconfig with other choices' naming
>     convention
>   nohz: Improve a bit the full dynticks Kconfig documentation
> 
> Paul E. McKenney (1):
>   rcu: Kick adaptive-ticks CPUs that are holding up RCU grace periods
> 
>  Documentation/kernel-parameters.txt |    4 +-
>  include/linux/tick.h                |    6 ++--
>  kernel/rcutree.c                    |   10 ++++++
>  kernel/rcutree.h                    |    1 +
>  kernel/rcutree_plugin.h             |   18 +++++++++++
>  kernel/sched/core.c                 |    6 ++--
>  kernel/time/Kconfig                 |   26 ++++++++++------
>  kernel/time/tick-broadcast.c        |    2 +-
>  kernel/time/tick-common.c           |    2 +-
>  kernel/time/tick-sched.c            |   54 +++++++++++++++++-----------------
>  10 files changed, 82 insertions(+), 47 deletions(-)

Pulled, thanks Frederic!

	Ingo
