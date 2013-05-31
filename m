Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3EaQBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:01:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44150 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3EaQBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:01:11 -0400
Date: Fri, 31 May 2013 18:01:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
Message-ID: <20130531160101.GB5910@twins.programming.kicks-ass.net>
References: <1369943981.26799.43.camel@gandalf.local.home>
 <20130531134319.GE5932@somewhere>
 <1370013528.26799.49.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370013528.26799.49.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:18:48AM -0400, Steven Rostedt wrote:
> I'll rewrite the patch and send it out for another review.

This is the only part I read in detail and marked the thread read!

Awaiting v2 :-)
