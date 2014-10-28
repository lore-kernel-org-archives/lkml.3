Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaJ1Br0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 21:47:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51829 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaJ1BrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 21:47:25 -0400
Message-ID: <544EF59E.90304@huawei.com>
Date: Tue, 28 Oct 2014 09:47:10 +0800
From: Yao Dongdong <yaodongdong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2]sched:add check of shallowest_idle_cpu before search
 for least_loaded_cpu
References: <544E1348.4050100@huawei.com> <20141027123056.GE3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141027123056.GE3337@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.110.51.36]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/27 20:30, Peter Zijlstra wrote:
> Please as to try again:
>
> Applying patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch
> patching file kernel/sched/fair.c
> Hunk #1 FAILED at 4446.
> 1 out of 1 hunk FAILED -- rejects in file kernel/sched/fair.c
> Patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch does not apply (enforce with -f)
> quilt returned 1, with 0 fuzz and 1 rejects
> use quilt -f? y/n [y]: y
> Applying patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch
> patching file kernel/sched/fair.c
> Hunk #1 FAILED at 4446.
> 1 out of 1 hunk FAILED -- saving rejects to file kernel/sched/fair.c.rej
> Applied patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch (forced; needs refresh)
> reject patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch file kernel/sched/fair.c hunk 1 line 4
> [a]uto[m]erge,edit [f]ile [p]atch [r]ej,[n]ext,[d]elete: [amfdprn]: m
> rej started:
> [a]uto[m]erge,edit [f]ile [p]atch [r]ej,[n]ext,[d]elete: [amfdprn]:     kernel/sched/fair.c: 1 matched, 0 conflicts remain
> n
> patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch done [s]top, [n]ext, [r]efresh [snr]: r
> WARNING: Use a single space after Signed-off-by:
> #13: 
> Signed-off-by:yaodongdong@huawei.com
>
> ERROR: code indent should use tabs where possible
> #25: FILE: kernel/sched/fair.c:4644:
> +               } else if (shallowest_idle_cpu == -1) {$
>
> WARNING: please, no spaces at the start of a line
> #25: FILE: kernel/sched/fair.c:4644:
> +               } else if (shallowest_idle_cpu == -1) {$
>
> total: 1 errors, 2 warnings, 8 lines checked
>
> NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
>       scripts/cleanfile
>
> .
>
I 'm sorry, and i will fix and resend another one.

Thanks,
Yao Dongdong

