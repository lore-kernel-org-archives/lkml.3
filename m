Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3JNMjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:39:01 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:65498 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3JNMjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:39:00 -0400
Date: Mon, 14 Oct 2013 14:38:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 00/14] sched: SCHED_DEADLINE v8
Message-ID: <20131014123855.GA25046@gmail.com>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <20131014122424.GK3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014122424.GK3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Oct 14, 2013 at 12:43:32PM +0200, Juri Lelli wrote:
> > Hello everyone,
> > 
> > here we go with a new version of the SCHED_DEADLINE patchset (v8). I know that
> > it has been a while since I released last version [1], but I thought not to
> > spam the mailing list with simple updates. Well... this IS basically an update
> > to 3.12-rc5, but it comes right before the next Kernel Summit and Real Time
> > Linux Workshop and, since I'll be present at both events, it is probably time
> > to fire-up the discussion again.
> 
> So I feel we should just merge this stuff already; [...]

Fully agreed - this has been going on for a long time and the patch-set 
has settled down nicely.

> [...] the only 'issue' I have is the cgroup abi muck. We clearly need a 
> bit more discussion on what/how we want things there but there are no 
> easy answers :/ So I'd say lets try this and see where we'll find 
> ourselves.

I'd suggest we leave out the cgroup ABI muck from the first round of 
upstream merge - do it in a second round, that will give it more 
attention.

Thanks,

	Ingo
