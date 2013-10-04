Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3JDQ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:28:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50783 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab3JDQ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:28:20 -0400
Date: Fri, 4 Oct 2013 18:28:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131004162804.GR3081@twins.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
 <20130927091427.GE24743@yliu-dev.sh.intel.com>
 <20130927152908.GE15690@laptop.programming.kicks-ass.net>
 <20131004080909.GP26785@twins.programming.kicks-ass.net>
 <20131004105342.20c00a41@gandalf.local.home>
 <20131004152826.GP3081@twins.programming.kicks-ass.net>
 <20131004115712.40c62743@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004115712.40c62743@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 11:57:12AM -0400, Steven Rostedt wrote:
> > +  need-resched:
> > +	'N' both TIF_NEED_RESCHED and PREEMPT_NEED_RESCHED is set,
> > +	'n' only TIF_NEED_RESCHED is set,
> > +	'p' only PREEMPT_NEED_RESCHED is set,
> > +	'.' otherwise.
> 
> Yes this is actually good enough. I'll have to spend time to explain
> this better. But I'll let you off the hook from doing it for me ;-)

beware; such endevours might lead to books and those are typically out
of date by the time they hit the street -- ie. they're a fair waste of
time ;-)
