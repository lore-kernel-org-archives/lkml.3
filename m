Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbaEPIP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:15:27 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:37495 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbaEPIPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:15:17 -0400
Message-ID: <5375C907.7060601@linux.vnet.ibm.com>
Date: Fri, 16 May 2014 16:15:03 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <20140514094426.GF30445@twins.programming.kicks-ass.net> <5374387E.4080802@linux.vnet.ibm.com> <20140515083531.GE30445@twins.programming.kicks-ass.net> <53747EE4.3020605@linux.vnet.ibm.com> <20140515090638.GI30445@twins.programming.kicks-ass.net> <53748A5D.6070605@linux.vnet.ibm.com> <20140515115751.GK30445@twins.programming.kicks-ass.net> <5375768F.1010000@linux.vnet.ibm.com> <1400208690.7133.11.camel@marge.simpson.net> <53759303.40409@linux.vnet.ibm.com> <20140516075421.GL11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140516075421.GL11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051608-5564-0000-0000-00000DB6A609
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 03:54 PM, Peter Zijlstra wrote:
[snip]
>>> Right.  I played a little (sane groups), saw load balancing as well.
>>
>> Yeah, now we found that even l2 groups will face the same issue, allow
>> me to re-list the details here:
> 
> Hmm, that _should_ more or less work and does indeed suggest there's
> something iffy.

Yeah, sane group topology also issued... besides the sleeper bonus, it
seems like the root cause is tasks starting to gather, I plan to check
the difference on task load between two cases, see if there is a good
way to solve this problem :)

Regards,
Michael Wang

> 

