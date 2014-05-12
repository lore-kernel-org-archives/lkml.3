Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbaELVv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:51:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:57054 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaELVv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:51:57 -0400
Date: Mon, 12 May 2014 23:52:07 +0200 (CEST)
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
In-Reply-To: <20140512173705.0bbdb675@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1405122344330.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140512173705.0bbdb675@gandalf.local.home>
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
> On Mon, 12 May 2014 20:45:32 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
>  
> >    Steven, I told you more than once, that your damned performance and
> >    feature mania is completely unacceptable.
> 
> 
> Yes you have, and now you are yelling at me for something I did 3 years
> ago. But this isn't one of my "performance and feature mania" things
> you bitched at me about. This is something *you* asked me to look at!
> 
> http://marc.info/?l=linux-kernel&m=129242481625261
> 
> The "stress test" you recommend back then was just to port it to -rt
> and test it there. Which I did, and it found various issues where I
> helped Lai fix.

And that's an excuse to merge stuff which leaves trainwrecks behind it?

Steven, start getting adult and admit your failures.

I'm cutting it right here as the following is just your attempt to
redirect the failure to me.

Yes, I made a mistake. The very mistake of trusting you.

That'll not happen again.

	Thomas


