Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3KHHiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:38:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44026 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3KHHiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:38:17 -0500
Date: Fri, 8 Nov 2013 08:37:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, oleg@redhat.com,
        dhowells@redhat.com, willy@linux.intel.com, tglx@linutronix.de,
        rostedt@goodmis.org, airlied@gmail.com,
        maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 0/8] Move locking primitives into kernel/locking/
Message-ID: <20131108073748.GF19203@twins.programming.kicks-ass.net>
References: <20131105105244.666320103@infradead.org>
 <20131106142921.GJ18245@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106142921.GJ18245@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 06:29:21AM -0800, Paul E. McKenney wrote:
> On Tue, Nov 05, 2013 at 01:10:44PM +0100, Peter Zijlstra wrote:
> > Hi all,
> > 
> > During Kernel Summit Dave mentioned that there wasn't a clear maintainer for
> > locking bits.
> > 
> > To remedy this Ingo suggested gathering all the various locking primitives and
> > lockdep into a single place: kernel/locking/.
> > 
> > I would further like to propose a MAINTAINERS entry like:
> > 
> > LOCKING
> > M:      Ingo Molnar <mingo@redhat.com>
> > M:      Peter Zijlstra <peterz@infradead.org>
> > M:	Oleg Nesterov <oleg@redhat.com>
> > M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > M:	Linus Torvalds <torvalds@linux-foundation.org>
> > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking/core
> > S:      Maintained
> > F:      kernel/locking/
> > 
> > Because for most 'fun' locking discussions we usually end up with at least
> > those people anyway :-)
> > 
> > Comments?
> 
> OK, I am in.
> 
> How are we organizing this?  I could imagine divvying up the various
> types of locks, having a minimum number of reviews or acks coupled
> with a maximum review time, or just requiring the full set of reviews
> and acks given the criticality of locking code.  Other approaches?

I would suggest something like an ack/review of at least 3/5, no hard
deadline, because as you say, its better to get locking right :-)

