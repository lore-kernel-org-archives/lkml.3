Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3ILGiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:38:46 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:41487 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3ILGio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:38:44 -0400
Date: Thu, 12 Sep 2013 08:38:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20130912063840.GB11583@gmail.com>
References: <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909132343.GN3966@linux.vnet.ibm.com>
 <20130909133604.GC31370@twins.programming.kicks-ass.net>
 <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
 <20130909150854.GD26785@twins.programming.kicks-ass.net>
 <0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com>
 <20130909160024.GA25555@gmail.com>
 <0000014109c67b51-d6daa58f-d05a-4306-ae51-3fcf46ce5550-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014109c67b51-d6daa58f-d05a-4306-ae51-3fcf46ce5550-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Mon, 9 Sep 2013, Ingo Molnar wrote:
> 
> > So my NAK stands: you are still in denial, you should stop the silly 
> > arguing and you should stop wasting maintainer time. You need to 
> > address PeterZ's review feedback and fix the bugs in your patches, 
> > ASAP.
> 
> You are NAKing my patches that add the preempt checks? Now I am 
> confused. I thought you wanted those?

My NAK of the original patches stands until the debug checks are working 
and are put up for a merge. You were talking nonsense all around in this 
thread and I simply don't trust your promise, but I'll obviously trust a 
queued up fix.

Thanks,

	Ingo
