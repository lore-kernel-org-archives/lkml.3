Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaENO1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:27:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:44482 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaENO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:27:50 -0400
Date: Wed, 14 May 2014 16:28:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/3] irq_work: Implement remote queueing
In-Reply-To: <20140514135509.GL30445@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1405141626490.6261@ionos.tec.linutronix.de>
References: <1400019956-25511-1-git-send-email-fweisbec@gmail.com> <1400019956-25511-2-git-send-email-fweisbec@gmail.com> <20140514090629.GC30445@twins.programming.kicks-ass.net> <20140514113808.GA1278@localhost.localdomain> <20140514115406.GA11096@twins.programming.kicks-ass.net>
 <20140514121122.GC1278@localhost.localdomain> <20140514124150.GB11096@twins.programming.kicks-ass.net> <20140514135116.GD1278@localhost.localdomain> <20140514135509.GL30445@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Peter Zijlstra wrote:

> On Wed, May 14, 2014 at 03:51:19PM +0200, Frederic Weisbecker wrote:
> > > Anyway, if it turns out to really be needed, the split list doesn't
> > > sound bad.
> > 
> > Either that or we can remove LAZY stuff and wait to see if people complain :)
> 
> How big do we need tested? I'm fairly sure RHT has some medium silly
> boxes to run things on.

Poke Davidlohr and pretend it's a futex optimization.

He has access to a 160 way for futex tests :)

Thanks,

	tglx

 
