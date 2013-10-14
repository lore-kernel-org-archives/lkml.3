Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3JNNGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:06:03 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:35181 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3JNNGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:06:00 -0400
Message-ID: <525BEC34.8010207@gmail.com>
Date: Mon, 14 Oct 2013 15:05:56 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, g@twins.programming.kicks-ass.net
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
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
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-4-git-send-email-juri.lelli@gmail.com> <20131014111040.GA3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014111040.GA3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 01:10 PM, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 12:43:35PM +0200, Juri Lelli wrote:
>> +struct sched_dl_entity {
>> +	struct rb_node	rb_node;
>> +	int nr_cpus_allowed;
>> +
> 
> Please see:
> 
> 29baa7478ba4 sched: Move nr_cpus_allowed out of 'struct sched_rt_entity'
> 
> 

Yes, I already considered and used that. But, it is slipped into next patch :\.
I'll bring the change to this patch.

Thanks,

- Juri
