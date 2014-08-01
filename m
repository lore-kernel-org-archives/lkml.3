Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaHBGt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 02:49:58 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42510 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaHBGt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 02:49:56 -0400
Date: Fri, 1 Aug 2014 08:16:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140801151641.GG4784@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140729081416.GR20603@laptop.programming.kicks-ass.net>
 <20140729172304.GA16073@linux.vnet.ibm.com>
 <20140729173332.GM3935@laptop>
 <20140729180656.GY11241@linux.vnet.ibm.com>
 <1406726619.5889.17.camel@marge.simpson.net>
 <20140730142311.GJ11241@linux.vnet.ibm.com>
 <1406792228.6348.22.camel@marge.simpson.net>
 <20140731163819.GS11241@linux.vnet.ibm.com>
 <1406861975.5319.5.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406861975.5319.5.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080206-1542-0000-0000-000003B5BB85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:59:35AM +0200, Mike Galbraith wrote:
> On Thu, 2014-07-31 at 09:38 -0700, Paul E. McKenney wrote:
> 
> > Does building with CONFIG_NO_HZ_FULL_SYSIDLE=y slow things down even more?
> > If so, that would give me a rough idea of the cost of RCU's dyntick-idle
> > handling.
> 
> Nope.  Deltas are all down in the statistical frog hair.

OK, then I guess that trying to squeeze down RCU's dyntick-idle detection
won't be much help.  Worth a thought, though, and thank you for running
the tests!

							Thanx, Paul

