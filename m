Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaCJR3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:29:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:26718 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754486AbaCJR3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:29:42 -0400
Date: Mon, 10 Mar 2014 13:29:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] sched: Fix broken setscheduler()
Message-ID: <20140310132940.78e556c7@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1403062143360.18573@ionos.tec.linutronix.de>
References: <20140305232931.449eef8c@gandalf.local.home>
	<20140306115825.GS27965@twins.programming.kicks-ass.net>
	<20140306132040.781dbf18c9385a6112fbab2b@gmail.com>
	<20140306120438.638bfe94@gandalf.local.home>
	<alpine.DEB.2.02.1403062143360.18573@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 21:43:50 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:
 
> > Reading what the commit is suppose to do, I realize that the p->prio
> > can't be set if the task is boosted with a higher prio, but the
> > p->normal_prio still needs to be set regardless, otherwise, when the
> > task is deboosted, it wont get the new priority.
> 
> Indeed.

Is this an Acked-by?

Peter, can you pull this patch please, it is still broken in tip/master.

Thanks,

-- Steve

