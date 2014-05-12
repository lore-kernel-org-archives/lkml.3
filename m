Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaELWhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:37:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:57220 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaELWhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:37:10 -0400
Date: Tue, 13 May 2014 00:37:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
In-Reply-To: <20140512180839.2eb18000@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1405130020050.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140512173705.0bbdb675@gandalf.local.home> <alpine.DEB.2.02.1405122344330.6261@ionos.tec.linutronix.de> <20140512180839.2eb18000@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Steven Rostedt wrote:
> I did admit I made a mistake. If you read the rest of my email that you
> cut off, I said "Sure, I should have pushed Lai for that at the time.
> Lessons learned. I was expecting he would do so after we got to a final
> version of the patch but I was also working on other things at the time
> and forgot to remind him."
> 
> I even stated that I'm doing better now. That means I have learned from
> my mistakes. And continue to do so.

Sure, with your latest multi reader patches you break even the compile
with CONFIG_DEBUG_RT_MUTEXES=y due to:

+               debug_rt_mutex_print_deadlock(waiter);

I'm really impressed by your improvements.

Thanks,

	tglx
