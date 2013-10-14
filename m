Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3JNNWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:22:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56455 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab3JNNWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:22:45 -0400
Date: Mon, 14 Oct 2013 15:22:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
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
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 00/14] sched: SCHED_DEADLINE v8
Message-ID: <20131014132219.GL3081@twins.programming.kicks-ass.net>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <20131014122424.GK3081@twins.programming.kicks-ass.net>
 <20131014123855.GA25046@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014123855.GA25046@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 02:38:55PM +0200, Ingo Molnar wrote:
> > [...] the only 'issue' I have is the cgroup abi muck. We clearly need a 
> > bit more discussion on what/how we want things there but there are no 
> > easy answers :/ So I'd say lets try this and see where we'll find 
> > ourselves.
> 
> I'd suggest we leave out the cgroup ABI muck from the first round of 
> upstream merge - do it in a second round, that will give it more 
> attention.

I'm afraid that'd give rise to some very weird situations for people
using cgroups :/
