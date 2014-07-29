Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaG2Rhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:37:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaG2Rho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:37:44 -0400
Date: Tue, 29 Jul 2014 19:37:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 2/9] rcu: Provide cond_resched_rcu_qs()
 to force quiescent states in long loops
Message-ID: <20140729173733.GZ12054@laptop.lan>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1406588180-21933-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140729075536.GZ19379@twins.programming.kicks-ass.net>
 <20140729162236.GP11241@linux.vnet.ibm.com>
 <20140729172542.GK3935@laptop>
 <20140729173318.GW11241@linux.vnet.ibm.com>
 <20140729173600.GN3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729173600.GN3935@laptop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 07:36:00PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 29, 2014 at 10:33:18AM -0700, Paul E. McKenney wrote:
> > > No, but why can't we make the regular cond_resched() do this?
> > 
> > Well, I got a lot of grief when I tried it a few weeks ago.
> > 
> > But from what I can see, you are the maintainer or cond_resched(), so
> > if you are good with making the normal cond_resched() do this, I am
> > more than happy to make it so!  ;-)
> 
> Well, its the 'obvious' thing to do. But clearly I haven't tried so I'm
> blissfully unaware of any problems. And the Changelog didn't inform me
> either (you had a link in there, which I didn't read :-)

Then again, last time we touched cond_resched() we had a scalability
issue or somesuch, or am I misremembering things?
