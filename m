Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaELWIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:08:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:22330 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750866AbaELWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:08:44 -0400
Date: Mon, 12 May 2014 18:08:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
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
Message-ID: <20140512180839.2eb18000@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1405122344330.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de>
	<20140512173705.0bbdb675@gandalf.local.home>
	<alpine.DEB.2.02.1405122344330.6261@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 23:52:07 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 12 May 2014, Steven Rostedt wrote:
> > On Mon, 12 May 2014 20:45:32 -0000
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> >  
> > >    Steven, I told you more than once, that your damned performance and
> > >    feature mania is completely unacceptable.
> > 
> > 
> > Yes you have, and now you are yelling at me for something I did 3 years
> > ago. But this isn't one of my "performance and feature mania" things
> > you bitched at me about. This is something *you* asked me to look at!
> > 
> > http://marc.info/?l=linux-kernel&m=129242481625261
> > 
> > The "stress test" you recommend back then was just to port it to -rt
> > and test it there. Which I did, and it found various issues where I
> > helped Lai fix.
> 
> And that's an excuse to merge stuff which leaves trainwrecks behind it?

A trainwreck that wasn't noticed in 3 years.

> 
> Steven, start getting adult and admit your failures.

I did admit I made a mistake. If you read the rest of my email that you
cut off, I said "Sure, I should have pushed Lai for that at the time.
Lessons learned. I was expecting he would do so after we got to a final
version of the patch but I was also working on other things at the time
and forgot to remind him."

I even stated that I'm doing better now. That means I have learned from
my mistakes. And continue to do so.

> 
> I'm cutting it right here as the following is just your attempt to
> redirect the failure to me.

No, I'm not trying to redirect the failure to you. I was trying to get
you to understand that actual scope of it.


> 
> Yes, I made a mistake. The very mistake of trusting you.
> 
> That'll not happen again.

I expect nothing less from you.

-- Steve
