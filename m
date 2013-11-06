Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3KFRXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:23:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33728 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3KFRXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:23:34 -0500
Date: Wed, 6 Nov 2013 18:23:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131106172324.GG16117@laptop.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
 <20130927091427.GE24743@yliu-dev.sh.intel.com>
 <20130927152908.GE15690@laptop.programming.kicks-ass.net>
 <20131106113704.41b6ed5c@gandalf.local.home>
 <20131106164525.GF16117@laptop.programming.kicks-ass.net>
 <20131106115800.05164696@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106115800.05164696@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 11:58:00AM -0500, Steven Rostedt wrote:
> On Wed, 6 Nov 2013 17:45:25 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, Nov 06, 2013 at 11:37:04AM -0500, Steven Rostedt wrote:
> 
> > This also wasn't the last version of the patch, I distinctly remember
> > you making me update some documentation crap.
> 
> Hmm, the later patches must be lost in my INBOX, which I'm currently
> trying to get back under control.

Same thread :-)

> Sure, but it still needs to go in with the sched code, as its dependent
> on new functions that I don't have.

These patches have been in -tip for weeks now, you should have it I
think.

> Just add my Acked-by: and I'll clean it up in 3.13.

I can do that. Thanks!


