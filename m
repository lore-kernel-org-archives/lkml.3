Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3IIQLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:11:36 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:46146 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3IIQLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:11:34 -0400
Date: Mon, 9 Sep 2013 18:11:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909161130.GA27188@gmail.com>
References: <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909132343.GN3966@linux.vnet.ibm.com>
 <20130909133604.GC31370@twins.programming.kicks-ass.net>
 <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
 <20130909150854.GD26785@twins.programming.kicks-ass.net>
 <0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com>
 <20130909160024.GA25555@gmail.com>
 <20130909120328.583a586d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909120328.583a586d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 9 Sep 2013 18:00:24 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > So my NAK stands: you are still in denial, you should stop the silly 
> > arguing and you should stop wasting maintainer time. You need to 
> > address PeterZ's review feedback and fix the bugs in your patches, 
> > ASAP.
> 
> To Christoph's credit. He did post patches with debug checks. We just 
> need to get around to review them.

I saw those, he posted 'needs testing' patches. He still behaved 
passive-aggressively, pretending that it was some difficult task to 
perform, as if we were pulling his teeth.

And in this thread he still arguing nonsense in the middle in the merge 
window, claiming that CONFIG_PREEMPT=y is 'academic' - when just a cursory 
look at lkml or just about anywhere else would tell him that amongst bug 
reporters on lkml it's as popular as the other preempt options.

Adding and keeping preempt checks is not rocket science.

The thing is, we should not be forced to shout at him at all: Christoph's 
should be _proactive_ in addressing the shortcomings that were readily 
pointed out literally years ago during review in a friendly fashion, 
instead of wasting a lot of people's time trying to argue around it...

Thanks,

	Ingo
