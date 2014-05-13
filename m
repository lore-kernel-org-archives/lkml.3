Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbaEMQMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:12:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44924 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaEMQMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:12:30 -0400
Date: Tue, 13 May 2014 09:12:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
Message-ID: <20140513161221.GG18164@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140512190438.314125476@linutronix.de>
 <20140512201700.999660035@linutronix.de>
 <5371B2D9.8060405@cn.fujitsu.com>
 <20140513084815.GB2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513084815.GB2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051316-8236-0000-0000-00000248E8B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 10:48:15AM +0200, Peter Zijlstra wrote:
> On Tue, May 13, 2014 at 01:51:21PM +0800, Lai Jiangshan wrote:
> > I considered you blamed to me.
> > I would feel better if you directly blamed to me.
> 
> Well, the way I see it all you're to blame for is 'forgetting' to update
> the rt mutex test for 3 years, and while that is unfortunate, the much
> bigger fail is merging the patch without it to begin with.
> 
> So in that respect Steven is primarily responsible for merging
> incomplete work.
> 
> Now Thomas was entirely grumpy from staring at bugs for a long while,
> which is entirely understandable. That said I don't think he went
> overboard calling Steven out on this.
> 
> Now, if you and Steve get this sorted, nothing really happened except
> that Thomas got grumpy, which is entirely normal, what else would he be?
> :-)

What Peter said!  ;-)

							Thanx, Paul

