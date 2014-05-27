Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaE0VDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:03:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:4408 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751991AbaE0VDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:03:23 -0400
Date: Tue, 27 May 2014 17:03:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH] sched/numa: Fix use of spin_{un}lock_irq() when
 interrupts are disabled
Message-ID: <20140527170321.76ef8c6c@gandalf.local.home>
In-Reply-To: <1401222025.5367.262.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20140527155251.5dc77977@gandalf.local.home>
	<1401222025.5367.262.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 13:20:25 -0700
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Your patch was mangled it seems...

Grumble. One of these days I'm going to hack the claws-mail client to
fix it's random decisions to "format" the entire email :-p

> 
> Fixes: 60e69eed85bb ("sched/numa: Fix task_numa_free() lockdep splat")

Thanks, I should have included that in my v2.

-- Steve

