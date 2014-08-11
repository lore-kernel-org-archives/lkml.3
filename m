Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaHKQPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:15:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43531 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaHKQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:15:39 -0400
Date: Mon, 11 Aug 2014 09:15:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140811161531.GA530@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
 <20140809160137.GJ5821@linux.vnet.ibm.com>
 <20140809181920.GO9918@twins.programming.kicks-ass.net>
 <20140809182400.GJ3588@twins.programming.kicks-ass.net>
 <20140810012924.GO5821@linux.vnet.ibm.com>
 <20140810081425.GT9918@twins.programming.kicks-ass.net>
 <20140811033048.GT5821@linux.vnet.ibm.com>
 <20140811115706.GX9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811115706.GX9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081116-0928-0000-0000-00000408C57F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 01:57:06PM +0200, Peter Zijlstra wrote:
> On Sun, Aug 10, 2014 at 08:30:48PM -0700, Paul E. McKenney wrote:
> > On Sun, Aug 10, 2014 at 10:14:25AM +0200, Peter Zijlstra wrote:
> 
> > > want want want, I want a damn pony but somehow I'm not getting one. Why
> > > are they getting this?
> > 
> > We can only be glad that my daughters' old My Little Pony toys are
> > long gone (http://en.wikipedia.org/wiki/My_Little_Pony).  Not sure I
> > would have been able to resist sending one along.  ;-)
> 
> LOL, I _knew_ someone was going to propose doing that ;-)

You know me too well, Peter!  ;-)

							Thanx, Paul

