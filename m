Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3ILOnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:43:15 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:46038 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab3ILOnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:43:14 -0400
Date: Thu, 12 Sep 2013 14:43:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
In-Reply-To: <20130912063840.GB11583@gmail.com>
Message-ID: <0000014112a03407-7ceda101-3abe-4eb3-ae4b-ca6b125b0d82-000000@email.amazonses.com>
References: <20130906174117.GU3966@linux.vnet.ibm.com> <20130906185927.GE2706@somewhere> <20130909105347.GK31370@twins.programming.kicks-ass.net> <20130909132343.GN3966@linux.vnet.ibm.com> <20130909133604.GC31370@twins.programming.kicks-ass.net>
 <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com> <20130909150854.GD26785@twins.programming.kicks-ass.net> <0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com> <20130909160024.GA25555@gmail.com>
 <0000014109c67b51-d6daa58f-d05a-4306-ae51-3fcf46ce5550-000000@email.amazonses.com> <20130912063840.GB11583@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.12-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Ingo Molnar wrote:

> My NAK of the original patches stands until the debug checks are working
> and are put up for a merge. You were talking nonsense all around in this
> thread and I simply don't trust your promise, but I'll obviously trust a
> queued up fix.

You could just pick up the existing preempt check patches and fix them up
and merge now saving me the work. We will have the checks immediately for
3.12. The conversion of all the source code from __get_cpu_var can be done
later.

It would not be that complicated to do even without my patches.




