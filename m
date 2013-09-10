Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3IJEHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:07:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3IJEHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:07:14 -0400
Message-ID: <1378786024.5486.78.camel@marge.simpson.net>
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
From: Mike Galbraith <mgalbraith@suse.de>
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
Date: Tue, 10 Sep 2013 06:07:04 +0200
In-Reply-To: <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
	 <20130906105934.GF20519@somewhere>
	 <20130906151851.GQ3966@linux.vnet.ibm.com>
	 <1378488088.31445.39.camel@edumazet-glaptop>
	 <20130906174117.GU3966@linux.vnet.ibm.com>
	 <20130906185927.GE2706@somewhere>
	 <20130909105347.GK31370@twins.programming.kicks-ass.net>
	 <20130909132343.GN3966@linux.vnet.ibm.com>
	 <20130909133604.GC31370@twins.programming.kicks-ass.net>
	 <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 14:49 +0000, Christoph Lameter wrote:

> Its just that PREEMPT kernels are
> not in use and AFAICT the full preempt stuff requires significant developer
> support and complicates the code without much benefit.

The openSUSE desktop kernel is PREEMPT, and presumably has users.

I use VOLUNTARY for my desktop, having zero tight latency constraints,
and not being into inflicting needless pain on poor defenseless boxen,
but lots of folks do use PREEMPT, and some of them may even need it.

-Mike

