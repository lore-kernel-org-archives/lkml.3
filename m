Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbaAUO4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:56:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:55718 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754827AbaAUO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:56:05 -0500
Date: Tue, 21 Jan 2014 09:55:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140121095559.67b86d9c@gandalf.local.home>
In-Reply-To: <20140120114606.GA31570@twins.programming.kicks-ass.net>
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
	<20140120112442.GA8907@austad.us>
	<20140120114606.GA31570@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014 12:46:06 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> > activates - released?
> > 
> > Since real-time papers from different rt-campus around the academia insist 
> > on using *slightly* different terminology, perhaps add a short dictionary 
> > for some of the more common terms?
> 
> Oh gawd, they really don't conform with their definitions? I'd not
> noticed that.
> 
> > D: relative deadline, typically N ms after release
> 
> You failed to define release :-) Its the 'wakeup' event, right? Where
> the activation would be the moment we actually schedule the
> job/instance?

It took me about 20 seconds to figure out what a "release" was too. ;-)

-- Steve
