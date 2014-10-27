Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaJ0MbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:31:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaJ0MbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:31:04 -0400
Date: Mon, 27 Oct 2014 13:30:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yao Dongdong <yaodongdong@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2]sched:add check of shallowest_idle_cpu before search
 for least_loaded_cpu
Message-ID: <20141027123056.GE3337@twins.programming.kicks-ass.net>
References: <544E1348.4050100@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544E1348.4050100@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please as to try again:

Applying patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch
patching file kernel/sched/fair.c
Hunk #1 FAILED at 4446.
1 out of 1 hunk FAILED -- rejects in file kernel/sched/fair.c
Patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch does not apply (enforce with -f)
quilt returned 1, with 0 fuzz and 1 rejects
use quilt -f? y/n [y]: y
Applying patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch
patching file kernel/sched/fair.c
Hunk #1 FAILED at 4446.
1 out of 1 hunk FAILED -- saving rejects to file kernel/sched/fair.c.rej
Applied patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch (forced; needs refresh)
reject patch patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch file kernel/sched/fair.c hunk 1 line 4
[a]uto[m]erge,edit [f]ile [p]atch [r]ej,[n]ext,[d]elete: [amfdprn]: m
rej started:
[a]uto[m]erge,edit [f]ile [p]atch [r]ej,[n]ext,[d]elete: [amfdprn]:     kernel/sched/fair.c: 1 matched, 0 conflicts remain
n
patches/yao_dongdong-sched_add_check_of_shallowest_idle_cpu_before_search_for_least_loaded_cpu.patch done [s]top, [n]ext, [r]efresh [snr]: r
WARNING: Use a single space after Signed-off-by:
#13: 
Signed-off-by:yaodongdong@huawei.com

ERROR: code indent should use tabs where possible
#25: FILE: kernel/sched/fair.c:4644:
+               } else if (shallowest_idle_cpu == -1) {$

WARNING: please, no spaces at the start of a line
#25: FILE: kernel/sched/fair.c:4644:
+               } else if (shallowest_idle_cpu == -1) {$

total: 1 errors, 2 warnings, 8 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile
