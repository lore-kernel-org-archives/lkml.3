Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3HAIab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:30:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47097 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3HAIa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:30:29 -0400
Date: Thu, 1 Aug 2013 10:29:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Kevin Hilman <khilman@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [GIT PULL] nohz patches for 3.12 preview v3
Message-ID: <20130801082959.GJ3008@twins.programming.kicks-ass.net>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 02:31:17AM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> So none of the patches from the previous v2 posting have changed.
> I've just added two more in order to fix build crashes reported
> by Wu Fengguang:
> 
>       hardirq: Split preempt count mask definitions
>       m68k: hardirq_count() only need preempt_mask.h
> 
> If no comment arise, I'll send a pull request to Ingo in a few days.

So I did a drive-by review and didn't spot anything really weird.

However, it would be very good to include some performance figures that
show what effect all this effort had.

I'm assuming its good (TM) ;-)
