Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaGJKAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:00:19 -0400
Received: from smtprelay0067.hostedemail.com ([216.40.44.67]:38686 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752078AbaGJKAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:00:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353
X-HE-Tag: door87_3c240519d8638
X-Filterd-Recvd-Size: 2896
Message-ID: <1404986412.8839.23.camel@joe-AO725>
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Date: Thu, 10 Jul 2014 03:00:12 -0700
In-Reply-To: <20140710093900.GV3935@laptop>
References: <20140708080908.GN19379@twins.programming.kicks-ass.net>
	 <1404842784.932.22.camel@joe-AO725>
	 <20140708204124.GW4603@linux.vnet.ibm.com>
	 <1404853264.932.52.camel@joe-AO725>
	 <20140708215229.GA4603@linux.vnet.ibm.com>
	 <1404857116.932.68.camel@joe-AO725>
	 <20140708222557.GF4603@linux.vnet.ibm.com>
	 <1404878965.932.87.camel@joe-AO725>
	 <20140709111427.GL4603@linux.vnet.ibm.com>
	 <1404912202.932.116.camel@joe-AO725> <20140710093900.GV3935@laptop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 11:39 +0200, Peter Zijlstra wrote:
> On Wed, Jul 09, 2014 at 06:23:22AM -0700, Joe Perches wrote:
> > > SCHEDULER:
> > > ...
> > > R:   Steven Rostedt <rostedt@goodmis.org> (kernel/sched/rt.c)
> > > R:   Juri Lelli <jundri.lelli@gmail.com>    (kernel/sched/deadline.c)
> > 
> > Maybe a better syntax might be something like:
> > R:	Steven Rostedt
> > 	F:	kernel/sched/rt.c
> > 
> > where optional F:/X: lines override the default
> > assumption of all F:/X: from the section.
> 
> Would RF: make sense? Instead of the indenting.

Maybe.

As a preface:

I doubt the need for associating a subset of the files
patterns for a subsystem with a particular reviewer.

If a reviewer is interested enough in a subsystem to
volunteer to read patches then that reviewer likely won't
be overburdened by getting a few more emailed patches
that may be outside a scope of interest.

To answer the question:

If it's done, there needs to be some mechanism to
associate a particular reviewer and the files.

Ordering of "letter:" types in MAINTAINERS is currently
unstructured.

Given a desire to have more than one reviewer interested
in different files, any subset use will either impose some
ordering requirement on the file list or some association
with the reviewer and the reviewer's file patterns of interest.

