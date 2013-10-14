Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3JNNv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:51:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57342 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3JNNv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:51:57 -0400
Date: Mon, 14 Oct 2013 15:51:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: g@twins.programming.kicks-ass.net, tglx@linutronix.de, mingo@redhat.com,
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
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures & implementation.
Message-ID: <20131014135137.GG28601@twins.programming.kicks-ass.net>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <1381747426-31334-4-git-send-email-juri.lelli@gmail.com>
 <20131014111040.GA3081@twins.programming.kicks-ass.net>
 <525BEC34.8010207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525BEC34.8010207@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 03:05:56PM +0200, Juri Lelli wrote:
> Yes, I already considered and used that. But, it is slipped into next patch :\.
> I'll bring the change to this patch.

Ah yes, the wandering hunks problem. I'm only too familiar with it :-(


