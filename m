Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaLNU3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:29:48 -0500
Received: from smtprelay0133.hostedemail.com ([216.40.44.133]:48092 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752836AbaLNU33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:29:29 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4250:5007:6261:7875:7886:7903:9010:9040:10007:10400:10848:10967:11232:11658:11914:12517:12519:12663:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: cow71_8cbf5ee7ad52e
X-Filterd-Recvd-Size: 1745
Date: Sun, 14 Dec 2014 15:29:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2 v2] tracing: Enable tracepoints early and allow
 printk to use them
Message-ID: <20141214152915.431f7aa8@gandalf.local.home>
In-Reply-To: <20141214201609.126831471@goodmis.org>
References: <20141214201609.126831471@goodmis.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 15:16:09 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> 1) Allow traceopoints to be enabled right after mm_init(). By passing
> in the trace_event= kernel command line parameter, tracepoints can be
> enabled at boot up. For debugging things like the initialization of
> interrupts, it is needed to have tracepoints enabled very early. People
> have asked about this before and this has been on my todo list. As it
> can be helpful for Thomas to debug his upcoming 3.20 IRQ work, I'm
> pushing this now. This way he can add tracepoints into the IRQ set up
> and have have users enable them when things go wrong.

Cut and paste is a bitch!

s/mm_init/rcu_init/

-- Steve
