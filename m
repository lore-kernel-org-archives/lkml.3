Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3JNMYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:24:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55066 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3JNMYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:24:48 -0400
Date: Mon, 14 Oct 2013 14:24:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 00/14] sched: SCHED_DEADLINE v8
Message-ID: <20131014122424.GK3081@twins.programming.kicks-ass.net>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 12:43:32PM +0200, Juri Lelli wrote:
> Hello everyone,
> 
> here we go with a new version of the SCHED_DEADLINE patchset (v8). I know that
> it has been a while since I released last version [1], but I thought not to
> spam the mailing list with simple updates. Well... this IS basically an update
> to 3.12-rc5, but it comes right before the next Kernel Summit and Real Time
> Linux Workshop and, since I'll be present at both events, it is probably time
> to fire-up the discussion again.

So I feel we should just merge this stuff already; the only 'issue' I
have is the cgroup abi muck. We clearly need a bit more discussion on
what/how we want things there but there are no easy answers :/ So I'd
say lets try this and see where we'll find ourselves.

Steve; could you go over the SMP push/pull bits as they're modeled after
the stuff you did for FIFO.


