Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3IINhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:37:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3IINg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:36:58 -0400
Date: Mon, 9 Sep 2013 15:36:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu, cl@linux.com
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909133604.GC31370@twins.programming.kicks-ass.net>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
 <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909132343.GN3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909132343.GN3966@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 06:23:43AM -0700, Paul E. McKenney wrote:
> And guys, I have to say that the advice on which per-CPU primitive to use
> varies wildly and randomly.  For all I know, each of you individually
> might well be sticking to the same story, but taken together, your
> collective advice is strongly resembling white noise.

Its partly because cl and I disagree on things. He doesn't seem to care
much about validation and believes that people will not make mistakes
with this stuff.

And partly because I didn't get what was going on. While Frederic's
explanation might be correct it was incomprehensible for me.
