Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaGHSGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:06:35 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:57571 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755405AbaGHSGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:06:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622
X-HE-Tag: form01_727280eb1f556
X-Filterd-Recvd-Size: 3074
Message-ID: <1404842784.932.22.camel@joe-AO725>
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Date: Tue, 08 Jul 2014 11:06:24 -0700
In-Reply-To: <20140708080908.GN19379@twins.programming.kicks-ass.net>
References: <20140707224146.GA9118@linux.vnet.ibm.com>
	 <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140708080908.GN19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 10:09 +0200, Peter Zijlstra wrote:
> On Mon, Jul 07, 2014 at 03:42:03PM -0700, Paul E. McKenney wrote:
> >  MAINTAINERS | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 1814075c0e74..92f2bf91eec1 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7405,6 +7405,9 @@ F:	kernel/rcu/torture.c
> >  
> >  RCUTORTURE TEST FRAMEWORK
> >  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > +R:	Steven Rostedt <rostedt@goodmis.org>
> > +R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > +R:	Lai Jiangshan <laijs@cn.fujitsu.com>
> >  L:	linux-kernel@vger.kernel.org
> >  S:	Supported
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> 
> OK,.. so if we're going to do this can we talk about the syntax here.
> 
> I would like to also use this for SCHED and PERF, but since both are
> rather big I would like to be able to subdivide things. Now I could of
> course go create many MAINTAINER sections, but that feels artificial.
> 
> So I would like to be able to write:
> 
> SCHEDULER:
> ...
> R:   Steven Rostedt <rostedt@goodmis.org> (kernel/sched/rt.c)
> R:   Juri Lelli <juri.lelli@gmail.com>    (kernel/sched/deadline.c)
> 
> or something like that. And here I've already done concessions in that
> the above is machine readable. Ideally I'd be able to say things like:
> 'for sched and numa related things' add 'rik and mel'.
> 
> Hmm, maybe we can look at the patch subject tag like: sched/numa or
> sched/rt or sched/deadline etc.. instead of the files touched.

I think it's best to use separate sections.

The parsing logic in get_maintainers is already ugly enough.


