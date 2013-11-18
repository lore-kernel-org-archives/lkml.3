Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3KRX7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:59:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54824 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3KRX7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:59:39 -0500
Message-ID: <528AA9E0.5010807@jp.fujitsu.com>
Date: Mon, 18 Nov 2013 18:59:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, pjt@google.com,
        akpm@linux-foundation.org, tglx@linutronix.de, lwoodman@redhat.com,
        linux-tip-commits@vger.kernel.org
CC: kosaki.motohiro@jp.fujitsu.com
Subject: Re: [tip:sched/urgent] sched: Optimize task_sched_runtime()
References: <20131111172925.GG26898@twins.programming.kicks-ass.net> <tip-911b2898b3c9fe0048e9485ad1629ed4fce330fd@git.kernel.org>
In-Reply-To: <tip-911b2898b3c9fe0048e9485ad1629ed4fce330fd@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-TM-AS-Product-Ver: IMSS-7.1.0.1403-6.8.0.1017-20300.003
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-MatchedRID: U43YD7H1LvyxiVrMUp+cq+5i6weAmSDKjLOy13Cgb4/adW4iYSMjUel5
	wWtrjgOt5KMcIo9TvZGWApYP9QuGdoCgLBJXz91XxvVtA+vAWcxu95mt47DzNoKwF4K/wIz9MXw
	w+T4dG2dOZTK8HIK769CIyqyxIIAq/cIyPrsuMWqEryjhqiyzyqILs34F37sThmBHPk++FRL6vi
	SyhRDzBXrkKP2xArsvnaqIT85KADJYe6RsTDPSfTl/1fD/GopdWQy9YC5qGvyLvqs87Ydq5s40q
	Flt0NYjC24oEZ6SpSk+Mqg+CyrtwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 12:25 PM, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  911b2898b3c9fe0048e9485ad1629ed4fce330fd
> Gitweb:     http://git.kernel.org/tip/911b2898b3c9fe0048e9485ad1629ed4fce330fd
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Mon, 11 Nov 2013 18:21:56 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 13 Nov 2013 13:33:54 +0100
> 
> sched: Optimize task_sched_runtime()
> 
> Large multi-threaded apps like to hit this using do_sys_times() and
> then queue up on the rq->lock.
> 
> Avoid when possible.
> 
> Larry reported ~20% performance increase his test case.
> 
> Reported-by: Larry Woodman <lwoodman@redhat.com>
> Suggested-by: Paul Turner <pjt@google.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Link: http://lkml.kernel.org/r/20131111172925.GG26898@twins.programming.kicks-ass.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

Sorry for the delay. I took a vacation. As you know, this patch originally
written me, then I already tested this. So, of course,

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

# S-O-B is better? dunno.



