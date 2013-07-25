Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3GYVEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:04:31 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41516 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab3GYVE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:04:29 -0400
Date: Thu, 25 Jul 2013 23:04:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Mike Galbraith <efault@gmx.de>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [GIT PULL] nohz fixes
Message-ID: <20130725210422.GA18254@gmail.com>
References: <1374692894-27202-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374692894-27202-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the timers/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	timers/urgent
> 
> Just one thing you need to know: you reported me that the warning was
> "too much" to tell the user that he can't use full dynticks due to unstable tsc.
> 
> I discussed that with Steve and we concluded that we could keep the warning but
> only trigger it if the user explicitly wants to use the full dynticks which we
> deduce by checking if he filled the nohz_full= boot parameter or he selected
> CONFIG_NO_HZ_FULL_ALL. This way we make sure that the user knows what's going
> on but only if he really expected to use it.
> 
> If you still consider the tainting warning to be too much a hammer, even if only
> real users are warned, then tell me and I'll change that to some way you
> prefer.
> 
> 
> Thanks,
> 	Frederic
> ---
> 
> Li Zhong (1):
>       nohz: fix compile warning in tick_nohz_init()
> 
> Steven Rostedt (1):
>       nohz: Do not warn about unstable tsc unless user uses nohz_full
> 
> 
>  kernel/time/tick-sched.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)

Pulled, thanks Frederic!

	Ingo
