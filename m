Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab3JNRfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:35:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35650 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab3JNRfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:35:20 -0400
Date: Mon, 14 Oct 2013 19:34:56 +0200
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
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures & implementation.
Message-ID: <20131014173456.GC2675@laptop.programming.kicks-ass.net>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <1381747426-31334-4-git-send-email-juri.lelli@gmail.com>
 <20131014114433.GE3081@twins.programming.kicks-ass.net>
 <525C22CB.7000200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525C22CB.7000200@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 06:58:51PM +0200, Juri Lelli wrote:
> On 10/14/2013 01:44 PM, Peter Zijlstra wrote:
> > On Mon, Oct 14, 2013 at 12:43:35PM +0200, Juri Lelli wrote:
> We discussed on this point in the past...

Ah, completely forgot about that; please update the comment that we
indeed use different clocks for deadline and runtime and that the full
ramifications need further study; but that deadline needs hard walltime
and clock_task is more natural for runtime.
