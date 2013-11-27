Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab3K0QDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:03:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:47264 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753244Ab3K0QDD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:03:03 -0500
Date: Wed, 27 Nov 2013 11:02:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 08/14] sched: add latency tracing for -deadline tasks.
Message-ID: <20131127110259.3ac57bd7@gandalf.local.home>
In-Reply-To: <20131127105616.6672624c@gandalf.local.home>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
	<20131120163318.10253e43@gandalf.local.home>
	<5295F711.5010708@gmail.com>
	<20131127091647.4e16ce53@gandalf.local.home>
	<20131127142649.GC13532@twins.programming.kicks-ass.net>
	<20131127143435.GD25043@gmail.com>
	<20131127145837.GE16796@laptop.programming.kicks-ass.net>
	<20131127153519.GA26095@gmail.com>
	<20131127154015.GG789@laptop.programming.kicks-ass.net>
	<20131127154600.GC26095@gmail.com>
	<20131127105616.6672624c@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013 10:56:16 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 27 Nov 2013 16:46:00 +0100
> Ingo Molnar <mingo@kernel.org> wrote:

> > So from C99 standard §6.7.8 (Initialization)/21:
> > 
> >     "If there are fewer initializers in a brace-enclosed list than 
> >   there are elements or members of an aggregate, or fewer characters 
> >   in a string literal used to initialize an array of known size than 
> >   there are elements in the array, the remainder of the aggregate 
> >   shall be initialized implicitly the same as objects that have static 
> >   storage duration."
> > 
> > static initialization == zeroing in this case.
> > 
> 
> The confusion here is that the above looks to be talking about arrays.
> But it really doesn't specify structures.

Bah, re-reading it, it does seem to talk about structures.

I hate reading specs, they learn how to write documentation from
lawyers.

-- Steve
