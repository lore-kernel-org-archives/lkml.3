Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3JHUlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:41:44 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55073 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3JHUln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:41:43 -0400
Date: Tue, 8 Oct 2013 13:41:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo.kernel.org@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131008204129.GS5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131002092217.784439754@infradead.org>
 <20131004204405.GU3081@twins.programming.kicks-ass.net>
 <20131004204438.GR26785@twins.programming.kicks-ass.net>
 <20131005080416.GA25193@gmail.com>
 <20131008095927.GS3081@twins.programming.kicks-ass.net>
 <20131008102331.GB8852@gmail.com>
 <20131008141657.GW5790@linux.vnet.ibm.com>
 <20131008194718.GD7315@gmail.com>
 <20131008200155.GD13848@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008200155.GD13848@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100820-1344-0000-0000-00000244D60C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:01:55PM +0200, Peter Zijlstra wrote:
> On Tue, Oct 08, 2013 at 09:47:18PM +0200, Ingo Molnar wrote:
> > To me it would sure look nice to have kernel/rcu/tree.c, 
> > kernel/rcu/tiny.c, kernel/rcu/core.c, etc.
> > 
> > [ ... and we would certainly also break new ground by introducing a
> >   "torture.c" file, for the first time in Linux kernel history! ;-) ]
> > 
> > But it's really your call, this is something you should only do if you are 
> > comfortable with it.
> 
> IFF we're going to restructure rcu; can we save the CPP some work and do
> away with rcu*_plugin.h ?

OK, I'll bite...  Where did you want to put the code instead?

							Thanx, Paul

