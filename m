Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3IIPrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:47:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28378 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3IIPrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:47:03 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=NufY4J3AAAAA:8 a=fxJcL_dCAAAA:8 a=cuYFA6U4GeWgkUuDIpsA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=re9sYKne76oA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 11:47:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20130909114700.76290b50@gandalf.local.home>
In-Reply-To: <20130909114116.209aa16b@gandalf.local.home>
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
	<20130909150854.GD26785@twins.programming.kicks-ass.net>
	<0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com>
	<20130909114116.209aa16b@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 11:41:16 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 9 Sep 2013 15:24:55 +0000
> Christoph Lameter <cl@linux.com> wrote:
> 
> > On Mon, 9 Sep 2013, Peter Zijlstra wrote:
> > 
> > > > Slander. Certainly validation is good. Its just that PREEMPT kernels are
> > > > not in use
> > >
> > > Complete bullshit, its part of the mainline kernel, lots of people run
> > > them -- including me, and any patch is supposed to keep it working.
> > 
> > Nonsense. There is no main line distro that supports full preempt. Its an
> > academic exercise.
> 
> Red Hat MRG supports PREEMPT_RT. And Debian has an option to use
> PREEMPT_RT too. Two big main line distros.
> 
> So please, cut out the "academic exercise" crap.

Ubuntu Lucid supplies a CONFIG_PREEMPT kernel too:

http://kernel.ubuntu.com/~kernel-ppa/configs/lucid/amd64--preempt

-- Steve
