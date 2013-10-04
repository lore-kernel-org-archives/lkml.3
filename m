Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3JDOni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:43:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48397 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3JDOni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:43:38 -0400
Date: Fri, 4 Oct 2013 16:43:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131004144319.GM3081@twins.programming.kicks-ass.net>
References: <20131003193319.GB17796@redhat.com>
 <20131003195026.GT5790@linux.vnet.ibm.com>
 <20131003200002.GA23768@redhat.com>
 <20131003211009.GA4127@redhat.com>
 <20131004071814.GS28601@twins.programming.kicks-ass.net>
 <20131004111513.GA5699@redhat.com>
 <20131004114442.GJ3081@twins.programming.kicks-ass.net>
 <20131004121300.GA7725@redhat.com>
 <20131004123806.GK3081@twins.programming.kicks-ass.net>
 <20131004133135.GA11097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004133135.GA11097@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 03:31:35PM +0200, Oleg Nesterov wrote:
> > I'm really starting to think we shouldn't do this in rcu_sync at all.
> 
> I do not really understand why you insist that rcu_sync() should not
> try to help to the users which need the exclusive mode.

But what other users; you yourself said that percpu-rwsem isn't one for
long if ever.
