Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3KEN0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:26:14 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49149 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3KEN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:26:13 -0500
Date: Tue, 5 Nov 2013 14:26:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        dhowells@redhat.com, willy@linux.intel.com, tglx@linutronix.de,
        airlied@gmail.com, maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/8] Move locking primitives into kernel/locking/
Message-ID: <20131105132609.GA12146@gmail.com>
References: <20131105105244.666320103@infradead.org>
 <20131105081838.27c7fcd4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105081838.27c7fcd4@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 05 Nov 2013 13:10:44 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
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
> 
> I wonder if it should be called kernel/locks, as that's less to type,
> smaller path names, and tastes good on bagels.

The subsystem and topic is generally called 'kernel locking' though, and 
that's what the tree branches have been called for the past couple of 
years as well.

Also, 'kernel lock' brings me back memories of the 'big kernel lock' - 
while 'kernel locks' brings verb/noun ambiguity and visuals of
'kernel locks up'.

As for typing legth: kernel/lo<Tab> autocompletion is your friend! :-)

All in one, I think kernel/locking/ is a better name.

Thanks,

	Ingo
