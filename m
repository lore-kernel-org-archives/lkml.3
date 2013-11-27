Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab3K0Pki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:40:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53746 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab3K0Pkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:40:37 -0500
Date: Wed, 27 Nov 2013 16:40:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Juri Lelli <juri.lelli@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com
Subject: Re: [PATCH 08/14] sched: add latency tracing for -deadline tasks.
Message-ID: <20131127154015.GG789@laptop.programming.kicks-ass.net>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
 <1383831828-15501-9-git-send-email-juri.lelli@gmail.com>
 <20131120163318.10253e43@gandalf.local.home>
 <5295F711.5010708@gmail.com>
 <20131127091647.4e16ce53@gandalf.local.home>
 <20131127142649.GC13532@twins.programming.kicks-ass.net>
 <20131127143435.GD25043@gmail.com>
 <20131127145837.GE16796@laptop.programming.kicks-ass.net>
 <20131127153519.GA26095@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127153519.GA26095@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 04:35:19PM +0100, Ingo Molnar wrote:
> So why does GCC then behave like this:

I think because its a much saner behaviour; also it might still be the
spec actually says this, its a somewhat opaque text.

Anyway, yes GCC seems to behave as we 'expect' it to; I just can't find
the language spec actually guaranteeing this.
