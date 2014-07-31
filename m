Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaGaVI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:08:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60816 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaGaVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:08:27 -0400
Date: Thu, 31 Jul 2014 14:08:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 0/10] RCU-tasks implementation
Message-ID: <20140731210821.GD11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <871tt1qqcf.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871tt1qqcf.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073121-6688-0000-0000-000003AFFDC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 12:29:36PM -0700, Andi Kleen wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > Hello!
> >
> > This series provides a prototype of an RCU-tasks implementation, which has
> > been requested to assist with tramopoline removal.
> 
> Is that trampoline removal (whatever it is) important enough to justify
> adding that much new (and complicated) code? Are there other potential
> users of this? Is the long term maintenance cost justified?
> Will RCU keep growing forever?

My answers to all of these questions is "I don't know."

That said, I cannot resist pointing out that similar questions could be
asked of a great many other subsystems of the Linux kernel, or indeed
of the Linux kernel as a whole.  ;-)

And things do appear to be moving in a good direction for RCU-tasks:

	v1: 18 files changed, 749 insertions(+), 55 deletions(-)
	v2: 18 files changed, 590 insertions(+), 83 deletions(-)
	v3: 17 files changed, 447 insertions(+), 32 deletions(-)

The numbers for v3 are tentative, and might change based on test results.

							Thanx, Paul

