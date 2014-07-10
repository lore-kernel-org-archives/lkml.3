Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaGJJjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:39:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaGJJjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:39:43 -0400
Date: Thu, 10 Jul 2014 11:39:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
Message-ID: <20140710093900.GV3935@laptop>
References: <20140708080908.GN19379@twins.programming.kicks-ass.net>
 <1404842784.932.22.camel@joe-AO725>
 <20140708204124.GW4603@linux.vnet.ibm.com>
 <1404853264.932.52.camel@joe-AO725>
 <20140708215229.GA4603@linux.vnet.ibm.com>
 <1404857116.932.68.camel@joe-AO725>
 <20140708222557.GF4603@linux.vnet.ibm.com>
 <1404878965.932.87.camel@joe-AO725>
 <20140709111427.GL4603@linux.vnet.ibm.com>
 <1404912202.932.116.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404912202.932.116.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 06:23:22AM -0700, Joe Perches wrote:

> > SCHEDULER:
> > ...
> > R:   Steven Rostedt <rostedt@goodmis.org> (kernel/sched/rt.c)
> > R:   Juri Lelli <jundri.lelli@gmail.com>    (kernel/sched/deadline.c)
> 
> Maybe a better syntax might be something like:
> R:	Steven Rostedt
> 	F:	kernel/sched/rt.c
> 
> where optional F:/X: lines override the default
> assumption of all F:/X: from the section.

Would RF: make sense? Instead of the indenting.
