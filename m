Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaGHUrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:47:17 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47446 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaGHUrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:47:16 -0400
Date: Tue, 8 Jul 2014 13:47:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/3] rcu: Update RCU maintainership
Message-ID: <20140708204709.GX4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707224146.GA9118@linux.vnet.ibm.com>
 <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772924-9423-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708175855.GA2927@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708175855.GA2927@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070820-7164-0000-0000-000002FB3401
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 10:58:55AM -0700, Josh Triplett wrote:
> On Mon, Jul 07, 2014 at 03:42:04PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Drop Dipankar Sarma at his request (https://lkml.org/lkml/2014/6/2/628),
> > add Josh Triplett based on long-term review, contributions, and
> > agreement to take on this role (https://lkml.org/lkml/2014/6/2/554).
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Got it, thank you!

> Does it make sense to keep separate entries for each of these, at this
> point, or should we just merge all of them into the main "READ-COPY
> UPDATE (RCU)" entry?

Good question!  Let's see how we feel about it now, and then again a
year from now.

							Thanx, Paul

> >  MAINTAINERS | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 92f2bf91eec1..922661d17083 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7405,6 +7405,7 @@ F:	kernel/rcu/torture.c
> >  
> >  RCUTORTURE TEST FRAMEWORK
> >  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > +M:	Josh Triplett <josh@joshtriplett.org>
> >  R:	Steven Rostedt <rostedt@goodmis.org>
> >  R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >  R:	Lai Jiangshan <laijs@cn.fujitsu.com>
> > @@ -7430,8 +7431,8 @@ S:	Supported
> >  F:	net/rds/
> >  
> >  READ-COPY UPDATE (RCU)
> > -M:	Dipankar Sarma <dipankar@in.ibm.com>
> >  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > +M:	Josh Triplett <josh@joshtriplett.org>
> >  R:	Steven Rostedt <rostedt@goodmis.org>
> >  R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >  R:	Lai Jiangshan <laijs@cn.fujitsu.com>
> > @@ -8214,6 +8215,7 @@ F:	mm/sl?b.c
> >  SLEEPABLE READ-COPY UPDATE (SRCU)
> >  M:	Lai Jiangshan <laijs@cn.fujitsu.com>
> >  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > +M:	Josh Triplett <josh@joshtriplett.org>
> >  R:	Steven Rostedt <rostedt@goodmis.org>
> >  R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >  L:	linux-kernel@vger.kernel.org
> > -- 
> > 1.8.1.5
> > 
> 

