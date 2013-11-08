Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab3KHXTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:19:38 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:48374 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab3KHXTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:19:36 -0500
Date: Fri, 8 Nov 2013 15:19:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, oleg@redhat.com,
        dhowells@redhat.com, willy@linux.intel.com, tglx@linutronix.de,
        rostedt@goodmis.org, airlied@gmail.com,
        maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 0/8] Move locking primitives into kernel/locking/
Message-ID: <20131108231931.GK18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131105105244.666320103@infradead.org>
 <20131106142921.GJ18245@linux.vnet.ibm.com>
 <20131108073748.GF19203@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108073748.GF19203@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110823-1344-0000-0000-0000031E91E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 08:37:48AM +0100, Peter Zijlstra wrote:
> On Wed, Nov 06, 2013 at 06:29:21AM -0800, Paul E. McKenney wrote:
> > On Tue, Nov 05, 2013 at 01:10:44PM +0100, Peter Zijlstra wrote:
> > > Hi all,
> > > 
> > > During Kernel Summit Dave mentioned that there wasn't a clear maintainer for
> > > locking bits.
> > > 
> > > To remedy this Ingo suggested gathering all the various locking primitives and
> > > lockdep into a single place: kernel/locking/.
> > > 
> > > I would further like to propose a MAINTAINERS entry like:
> > > 
> > > LOCKING
> > > M:      Ingo Molnar <mingo@redhat.com>
> > > M:      Peter Zijlstra <peterz@infradead.org>
> > > M:	Oleg Nesterov <oleg@redhat.com>
> > > M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > M:	Linus Torvalds <torvalds@linux-foundation.org>
> > > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking/core
> > > S:      Maintained
> > > F:      kernel/locking/
> > > 
> > > Because for most 'fun' locking discussions we usually end up with at least
> > > those people anyway :-)
> > > 
> > > Comments?
> > 
> > OK, I am in.
> > 
> > How are we organizing this?  I could imagine divvying up the various
> > types of locks, having a minimum number of reviews or acks coupled
> > with a maximum review time, or just requiring the full set of reviews
> > and acks given the criticality of locking code.  Other approaches?
> 
> I would suggest something like an ack/review of at least 3/5, no hard
> deadline, because as you say, its better to get locking right :-)

Works for me!

							Thanx, Paul

