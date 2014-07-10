Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaGJXQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:16:35 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36835 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaGJXQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:16:34 -0400
Date: Thu, 10 Jul 2014 16:16:23 -0700
From: josh@joshtriplett.org
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
Message-ID: <20140710231623.GA23176@cloud>
References: <20140708204124.GW4603@linux.vnet.ibm.com>
 <1404853264.932.52.camel@joe-AO725>
 <20140708215229.GA4603@linux.vnet.ibm.com>
 <1404857116.932.68.camel@joe-AO725>
 <20140708222557.GF4603@linux.vnet.ibm.com>
 <1404878965.932.87.camel@joe-AO725>
 <20140709111427.GL4603@linux.vnet.ibm.com>
 <1404912202.932.116.camel@joe-AO725>
 <20140710093900.GV3935@laptop>
 <1404986412.8839.23.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404986412.8839.23.camel@joe-AO725>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 03:00:12AM -0700, Joe Perches wrote:
> On Thu, 2014-07-10 at 11:39 +0200, Peter Zijlstra wrote:
> > On Wed, Jul 09, 2014 at 06:23:22AM -0700, Joe Perches wrote:
> > > > SCHEDULER:
> > > > ...
> > > > R:   Steven Rostedt <rostedt@goodmis.org> (kernel/sched/rt.c)
> > > > R:   Juri Lelli <jundri.lelli@gmail.com>    (kernel/sched/deadline.c)
> > > 
> > > Maybe a better syntax might be something like:
> > > R:	Steven Rostedt
> > > 	F:	kernel/sched/rt.c
> > > 
> > > where optional F:/X: lines override the default
> > > assumption of all F:/X: from the section.
> > 
> > Would RF: make sense? Instead of the indenting.
> 
> Maybe.
> 
> As a preface:
> 
> I doubt the need for associating a subset of the files
> patterns for a subsystem with a particular reviewer.
> 
> If a reviewer is interested enough in a subsystem to
> volunteer to read patches then that reviewer likely won't
> be overburdened by getting a few more emailed patches
> that may be outside a scope of interest.

I agree.  And if a subset of files needs a separate set of maintainers
or reviewers, it doesn't seem excessive to split it into a separate
MAINTAINERS entry.  For instance, if you want kernel/sched/rt.c to have
an additional set of maintainers/reviewers, just add a MAINTAINERS entry
for "SCHEDULER - REALTIME" with an appropriate "F:" line.

- Josh Triplett
