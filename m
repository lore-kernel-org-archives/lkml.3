Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3JDLo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 07:44:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44434 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3JDLo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 07:44:57 -0400
Date: Fri, 4 Oct 2013 13:44:42 +0200
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
Message-ID: <20131004114442.GJ3081@twins.programming.kicks-ass.net>
References: <20131003184001.GM28601@twins.programming.kicks-ass.net>
 <20131003184719.GA11996@redhat.com>
 <20131003192135.GR5790@linux.vnet.ibm.com>
 <20131003193206.GA17796@redhat.com>
 <20131003193319.GB17796@redhat.com>
 <20131003195026.GT5790@linux.vnet.ibm.com>
 <20131003200002.GA23768@redhat.com>
 <20131003211009.GA4127@redhat.com>
 <20131004071814.GS28601@twins.programming.kicks-ass.net>
 <20131004111513.GA5699@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004111513.GA5699@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 01:15:13PM +0200, Oleg Nesterov wrote:
> > What's exclusive to mean? One writer at a time?
> 
> Yes,

I'm not entirely sure what the advantage is of having that logic in this
primitive. Shouldn't that be something the user of this rcu_sync stuff
does (or not) depending on its needs.


