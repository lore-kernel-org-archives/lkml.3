Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaGAIjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:39:12 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36359 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbaGAIjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:39:08 -0400
Message-ID: <53B273A2.5050500@linux.vnet.ibm.com>
Date: Tue, 01 Jul 2014 16:38:58 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com> <20140623094251.GS19860@laptop.programming.kicks-ass.net> <53A8F1DE.2060908@linux.vnet.ibm.com> <20140701082020.GL6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140701082020.GL6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070108-9264-0000-0000-0000066DCEBA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 04:20 PM, Peter Zijlstra wrote:
[snip]
>>
>> Just wondering could we make this another scheduler feature?
> 
> No; sched_feat() is for debugging, BIG CLUE: its guarded by
> CONFIG_SCHED_DEBUG, anybody using it in production or anywhere else is
> broken.
> 
> If people are using it, I should remove or at least randomize the
> interface.

Fair enough... but is there any suggestions on how to handle this issue?

Currently when dbench running with stress, it could only gain one CPU,
and cpu-cgroup cpu.shares is meaningless, is there any good methods to
address that?

Regards,
Michael Wang

> 

