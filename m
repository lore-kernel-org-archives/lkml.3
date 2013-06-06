Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab3FFKIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:08:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3FFKIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:08:14 -0400
Date: Thu, 6 Jun 2013 12:07:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
Message-ID: <20130606100752.GG8923@twins.programming.kicks-ass.net>
References: <1369943981.26799.43.camel@gandalf.local.home>
 <20130531134319.GE5932@somewhere>
 <1370013528.26799.49.camel@gandalf.local.home>
 <20130531160101.GB5910@twins.programming.kicks-ass.net>
 <1370050218.26799.87.camel@gandalf.local.home>
 <20130604122712.GE14973@somewhere>
 <1370355416.26799.119.camel@gandalf.local.home>
 <20130605114559.GE8923@twins.programming.kicks-ass.net>
 <1370439709.9844.17.camel@gandalf.local.home>
 <1370486988.9844.24.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370486988.9844.24.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:49:48PM -0400, Steven Rostedt wrote:
> Peter,
> 
> Are you fine with this answer, or do you still believe I should put it
> into sched/core.c?

Its ok I suppose. I just had to wrap my head around this
context_tracking muck; first time I ever looked at it.

> I switched it to EXPORT_SYMBOL_GPL, so that only GPL modules may use
> preempt_enable_notrace().
> 
> Are you OK with this?

Yep, applied.
