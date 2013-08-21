Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3HUQsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:48:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab3HUQsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:48:09 -0400
Date: Wed, 21 Aug 2013 18:41:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130821164146.GA15194@redhat.com>
References: <20130820084405.GC3258@twins.programming.kicks-ass.net> <52138BE9.5090005@linux.intel.com> <20130820160146.GG3258@twins.programming.kicks-ass.net> <20130820163312.GA17957@redhat.com> <20130820175429.GI3258@twins.programming.kicks-ass.net> <20130820182553.GB22287@redhat.com> <20130821083130.GM3258@twins.programming.kicks-ass.net> <20130821113551.GA1472@redhat.com> <20130821123311.GA31370@twins.programming.kicks-ass.net> <20130821142356.GC31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821142356.GC31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Peter Zijlstra wrote:
>
> The other consideration is that this adds two branches to the normal
> schedule path. I really don't know what the regular ratio between
> schedule() and io_schedule() is -- and I suspect it can very much depend
> on workload -- but it might be a net loss due to that, even if it makes
> io_schedule() 'lots' cheaper.

Yes, agreed. Please ignore it for now, I didn't try to actually suggest
this change. And even if this is fine perfomance wise, this needs some
benchmarking.

Well. actually I have a vague feeling that _perhaps_ this change can
help to solve other problems we are discussing, but I am not sure and
right now I can't even explain the idea to me.

In short: please ignore ;)

Oleg.

