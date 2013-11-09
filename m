Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3KIQB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 11:01:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40302 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3KIQBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 11:01:24 -0500
Date: Sat, 9 Nov 2013 17:01:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
Message-ID: <20131109160120.GD4971@laptop.programming.kicks-ass.net>
References: <20130626122408.GJ28407@twins.programming.kicks-ass.net>
 <20130626155325.GB7399@gmail.com>
 <51CB4328.7010006@oracle.com>
 <20130627090722.GC4398@gmail.com>
 <51CC4461.50207@oracle.com>
 <51DA127E.3040706@oracle.com>
 <20130708083914.GB3948@gmail.com>
 <5231FCA1.4090803@oracle.com>
 <20130912180120.GB32511@gmail.com>
 <527D1992.9000209@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527D1992.9000209@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:04:18PM -0500, Sasha Levin wrote:

> >
> >* Sasha Levin <sasha.levin@oracle.com> wrote:
> >
> >>On 07/08/2013 04:39 AM, Ingo Molnar wrote:
> >>>
> >>>* Sasha Levin <sasha.levin@oracle.com> wrote:
> >>>
> >>>>>>The other issue is that with lock classes disabled you have to hit an
> >>>>>>actual deadlock to trigger any output.
> >>>>>>
> >>>>>>I.e. much of the power of lockdep is diminished :-/ When actual
> >>>>>>deadlocks are triggered then it's not particularly complex to debug
> >>>>>>user-space apps: gdb the hung task(s) and look at the backtraces.
> >>>>>
> >>>>>Lock classes are disabled only if you're using the LD_PRELOAD method
> >>>>>of testing. If you actually re-compile your code with the library (by
> >>>>>just including the header and setting a #define to enable it) you will
> >>>>>have lock classes.
> >>>>
> >>>>Hi Ingo,
> >>>>
> >>>>Just wondering if you're planning on pushing it over to Linus from your
> >>>>tree, or should I go ahead and do it on my own?
> >>>
> >>>PeterZ is in favor as well so I'll apply them after the merge window, for
> >>>v3.12.
> >>
> >>Hi Ingo,
> >>
> >>Do you intend to send liblockdep in this merge window as planned?
> >
> >If Peter agrees with them and picks them up then the next merge window
> >would be fine I guess.
> 
> Ping? Anyone?

Urgh, I missed Ingo throwing the ball back in my court.. sorry about
that. I'll have a look on Monday.
