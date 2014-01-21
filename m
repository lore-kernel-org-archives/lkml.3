Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaAUQ2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:28:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:53097 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754438AbaAUQ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:28:40 -0500
Date: Tue, 21 Jan 2014 11:28:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Luca Abeni <luca.abeni@unitn.it>, Henrik Austad <henrik@austad.us>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140121112837.43b08f22@gandalf.local.home>
In-Reply-To: <20140121135559.GK30183@twins.programming.kicks-ass.net>
References: <1390214440-2711-1-git-send-email-juri.lelli@gmail.com>
	<20140120112442.GA8907@austad.us>
	<52DD1377.5090201@gmail.com>
	<20140120131616.GB8907@austad.us>
	<52DD2711.9080504@unitn.it>
	<20140121102016.GA12002@austad.us>
	<52DE5B7F.8020900@unitn.it>
	<20140121123334.GJ30183@twins.programming.kicks-ass.net>
	<52DE6D21.1080602@unitn.it>
	<20140121135559.GK30183@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014 14:55:59 +0100
Peter Zijlstra <peterz@infradead.org> wrote:


> > >I would strongly urge you not to use that as an example, because its
> > >dead wrong design. An RT thread (be it RR,FIFO or DL) should _NEVER_ do
> > >blocking IO.
> > Well, but it does happen in reality :)
> 
> Yeah, I know, my point was more about not encouraging people to do this
> by explicitly mentioning it.

Unless it is mentioned that this is fine for soft real-time uses, such
as what Luca described (mplayer and possibly Jack). Tools where missing
a deadline does not crash the system, but just reduces quality.

-- Steve
