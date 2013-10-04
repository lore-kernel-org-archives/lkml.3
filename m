Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3JDOxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:53:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:57588 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754120Ab3JDOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:53:44 -0400
Date: Fri, 4 Oct 2013 10:53:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131004105342.20c00a41@gandalf.local.home>
In-Reply-To: <20131004080909.GP26785@twins.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
	<20130927091427.GE24743@yliu-dev.sh.intel.com>
	<20130927152908.GE15690@laptop.programming.kicks-ass.net>
	<20131004080909.GP26785@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Oct 2013 10:09:09 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Sep 27, 2013 at 05:29:08PM +0200, Peter Zijlstra wrote:
> > Subject: ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Fri Sep 27 17:11:00 CEST 2013
> > 
> > Since we now have two need_resched states; trace the two so we can
> > observe discrepancies.
> > 
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> 
> Steve, if you're done conferencing.. any objections?
> 

Taking a quick look, my only objection so far is that the change log is
rather flimsy. What are the two states and what are their dependencies?

In other words, what does these flags in the trace actually mean?
Probably need to add comments in the code and/or update the
Documentation section

-- Steve
