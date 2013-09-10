Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3IJV23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:28:29 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:58981 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844Ab3IJV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:28:28 -0400
Date: Tue, 10 Sep 2013 21:28:27 +0000
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
In-Reply-To: <20130909160024.GA25555@gmail.com>
Message-ID: <0000014109c67b51-d6daa58f-d05a-4306-ae51-3fcf46ce5550-000000@email.amazonses.com>
References: <20130906151851.GQ3966@linux.vnet.ibm.com> <1378488088.31445.39.camel@edumazet-glaptop> <20130906174117.GU3966@linux.vnet.ibm.com> <20130906185927.GE2706@somewhere> <20130909105347.GK31370@twins.programming.kicks-ass.net> <20130909132343.GN3966@linux.vnet.ibm.com>
 <20130909133604.GC31370@twins.programming.kicks-ass.net> <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com> <20130909150854.GD26785@twins.programming.kicks-ass.net> <0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com>
 <20130909160024.GA25555@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.10-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Ingo Molnar wrote:

> So my NAK stands: you are still in denial, you should stop the silly
> arguing and you should stop wasting maintainer time. You need to address
> PeterZ's review feedback and fix the bugs in your patches, ASAP.

You are NAKing my patches that add the preempt checks? Now I am confused.
I thought you wanted those?

