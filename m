Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3KFQ6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:58:03 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10462 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754582Ab3KFQ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:58:01 -0500
Date: Wed, 6 Nov 2013 11:58:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131106115800.05164696@gandalf.local.home>
In-Reply-To: <20131106164525.GF16117@laptop.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
	<20130927091427.GE24743@yliu-dev.sh.intel.com>
	<20130927152908.GE15690@laptop.programming.kicks-ass.net>
	<20131106113704.41b6ed5c@gandalf.local.home>
	<20131106164525.GF16117@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 17:45:25 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Nov 06, 2013 at 11:37:04AM -0500, Steven Rostedt wrote:

> This also wasn't the last version of the patch, I distinctly remember
> you making me update some documentation crap.

Hmm, the later patches must be lost in my INBOX, which I'm currently
trying to get back under control.

 
> > Simply because I find switch statements easier to read than else if
> > statements.
> 
> Sure whatever your code ;-), but says he who wrote:
> 
> 	hardsoft_irq =
> 		(hardirq && softirq) ? 'H' :
> 		hardirq ? 'h' :
> 		softirq ? 's' :
> 		'.';

Hehe, I like that better that else if too :-)

> 
> Just apply the later patch and change it however you like.

Sure, but it still needs to go in with the sched code, as its dependent
on new functions that I don't have.

Just add my Acked-by: and I'll clean it up in 3.13.

Thanks!

-- Steve
