Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3IYNpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:45:47 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59394 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab3IYNpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:45:45 -0400
Date: Wed, 25 Sep 2013 06:45:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/6] Idle entry/exit changes for 3.13
Message-ID: <20130925134534.GP9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130925014954.GA32109@linux.vnet.ibm.com>
 <20130925040809.GD2016@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925040809.GD2016@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092513-0320-0000-0000-0000011F51FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 09:08:10PM -0700, Josh Triplett wrote:
> On Tue, Sep 24, 2013 at 06:49:55PM -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > This series updates RCU's idle entry/exit processing:
> > 
> > 1.	Remove redundant code from rcu_cleanup_after_idle().
> > 
> > 2.	Throttle rcu_try_advance_all_cbs() execution to avoid kbuild
> > 	slowdowns.
> > 
> > 3.	Throttle non-lazy-callback-induced invoke_rcu_core() invocations.
> > 
> > 4.	Add primitive to determine whether it is safe to enter an RCU
> > 	read-side critical section.
> > 
> > 5.	Upgrade EXPORT_SYMBOL() to EXPORT_SYMBOL_GPL().
> > 
> > 6.	Change rcu_is_cpu_idle() function to __rcu_is_watching() for
> > 	naming consistency.
> 
> For all six:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Got it, thank you for reviewing!

							Thanx, Paul

