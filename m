Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3IINxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:53:43 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47170 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab3IINxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:53:42 -0400
Date: Mon, 9 Sep 2013 06:53:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu, cl@linux.com
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909135320.GS3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909132343.GN3966@linux.vnet.ibm.com>
 <20130909133604.GC31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909133604.GC31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090913-7182-0000-0000-00000856C5A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 03:36:04PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 09, 2013 at 06:23:43AM -0700, Paul E. McKenney wrote:
> > And guys, I have to say that the advice on which per-CPU primitive to use
> > varies wildly and randomly.  For all I know, each of you individually
> > might well be sticking to the same story, but taken together, your
> > collective advice is strongly resembling white noise.
> 
> Its partly because cl and I disagree on things. He doesn't seem to care
> much about validation and believes that people will not make mistakes
> with this stuff.

At some point, my only recourse would be to require an Acked-by from one
of you for any per-CPU changes proposed by the other.  I really hope that
it doesn't come to that, but this situation is getting a bit annoying.

> And partly because I didn't get what was going on. While Frederic's
> explanation might be correct it was incomprehensible for me.

And I freely admit that the comments on rcu_is_cpu_idle() are completely
inadequate, and I do apologize for that.  Seemed clear at the time.
But then it always does, doesn't it?  ;-)

							Thanx, Paul

