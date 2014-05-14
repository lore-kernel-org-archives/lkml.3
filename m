Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaEND1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:27:49 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44052 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaEND1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:27:48 -0400
Message-ID: <5372E2A8.6070903@linux.vnet.ibm.com>
Date: Wed, 14 May 2014 11:27:36 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <537192D3.5030907@linux.vnet.ibm.com> <20140513094737.GU30445@twins.programming.kicks-ass.net> <53721FD4.6060300@redhat.com> <20140513142328.GE2485@laptop.programming.kicks-ass.net>
In-Reply-To: <20140513142328.GE2485@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051403-1396-0000-0000-000004D6564C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 10:23 PM, Peter Zijlstra wrote:
[snip]
> 
> The point remains though, don't use massive and awkward software stacks
> that are impossible to operate.
> 
> I you want to investigate !spinners, replace the ABC with slightly more
> complex loads like: https://lkml.org/lkml/2012/6/18/212

That's what we need, may be a little reform to enable multi-threads, or
may be add some locks... anyway, will redo the test and see what we
could found :)

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

