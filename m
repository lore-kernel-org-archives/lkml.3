Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3KUQr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:47:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:27376 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751226Ab3KUQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:47:25 -0500
Date: Thu, 21 Nov 2013 11:47:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, raistlin@linux.it,
        insop.song@gmail.com, liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 04/14] sched: SCHED_DEADLINE SMP-related data structures
 & logic.
Message-ID: <20131121114718.62cf3bbd@gandalf.local.home>
In-Reply-To: <20131121162631.GV4138@linux.vnet.ibm.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-5-git-send-email-juri.lelli@gmail.com>
	<20131120135134.4c57bcda@gandalf.local.home>
	<528E1508.7060305@gmail.com>
	<20131121160849.GU4138@linux.vnet.ibm.com>
	<528E31F2.7010702@gmail.com>
	<20131121162631.GV4138@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 08:26:31 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> > >> I guess "deadline tasks" is too much generic; "SCHED_DEADLINE tasks" too long;
> > >> "DL" or "-dl" can be associated to "download". Nothing special in the end, just
> > >> tought it was a reasonable abbreviation.
> > > 
> > > My guess was that "-deadline" was an abbreviation for tasks that had
> > > missed their deadline, just so you know.  ;-)
> > >
> > 
> > Argh! ;)
> > 
> > Actually, thinking about it twice: if we call "-rt tasks" things that are
> > governed by code that resides in sched/rt.c, we could agree on "-deadline
> > tasks" for things that pass through sched/deadline.c.
> 
> Actually, "SCHED_DEADLINE" isn't -that- much longer than "-deadline"
> and it does have the virtue of being unambiguous.
> 

 -sdl ?

Unless you are a fan of "Saturday Day Live!" (for the older generation
that can't stay awake for SNL)

-- Steve
