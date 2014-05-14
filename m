Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaENNd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:33:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:43892 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbaENNd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:33:58 -0400
Date: Wed, 14 May 2014 15:33:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <darren@dvhart.com>
cc: Carlos ODonell <carlos@redhat.com>, laijs@cn.fujitsu.com,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Roland McGrath <roland@hack.frob.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Clark Williams <williams@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
In-Reply-To: <CAGChsmO9GO1Z2VBbw7uLtTXpYowdoUQbK8C3=Dt2jtGAnc6D2A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1405141530520.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140512201700.999660035@linutronix.de> <5371B2D9.8060405@cn.fujitsu.com> <20140513084815.GB2485@laptop.programming.kicks-ass.net> <alpine.DEB.2.02.1405132117110.6261@ionos.tec.linutronix.de>
 <20140513162041.3405b668@gandalf.local.home> <20140513203619.GV18164@linux.vnet.ibm.com> <alpine.DEB.2.02.1405132301530.6261@ionos.tec.linutronix.de> <20140513220009.GW18164@linux.vnet.ibm.com> <20140513184430.5f2e12f8@gandalf.local.home>
 <20140513232710.GA18164@linux.vnet.ibm.com> <20140513195336.232bad54@gandalf.local.home> <alpine.DEB.2.02.1405140845330.6261@ionos.tec.linutronix.de> <CAGChsmO9GO1Z2VBbw7uLtTXpYowdoUQbK8C3=Dt2jtGAnc6D2A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Darren Hart wrote:
> On May 13, 2014 11:54 PM, "Thomas Gleixner" <tglx@linutronix.de> wrote:
> 
> I'll gladly accept new functional/algorithm type tests to futextest
> (performance stuff is probably going to perf instead, and Dave Miller beat

Dave Jones :)

> me to the fuzz tester with Trinity). But I think there is evidence we
> should build out the futex functional testing, and futextest seems a
> logical place for it.

Though as long as glibc is being silly we need to use the raw syscall
for it.

Thanks,

	tglx


