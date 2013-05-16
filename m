Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3EPG67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 02:58:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:12877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab3EPG6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 02:58:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="314464794"
Message-ID: <51948391.1020401@intel.com>
Date: Thu, 16 May 2013 14:58:25 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        tglx@linutronix.de, akpm@linux-foundation.org, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v6 6/8] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com> <1368199049-2798-7-git-send-email-alex.shi@intel.com> <20130513140625.GA15136@twins.programming.kicks-ass.net> <5191E75C.6030903@intel.com> <5194735B.5040005@linux.vnet.ibm.com>
In-Reply-To: <5194735B.5040005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 01:49 PM, Michael Wang wrote:
> On 05/14/2013 03:27 PM, Alex Shi wrote:
> [snip]
>> >  }
>> > diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
> This patch seems to be based on 3.10-rc1, while below one
> 
> [patch v6 3/8] sched: set initial value of runnable avg for new forked task
> 
> is conflict with 3.10-rc1... I think it may need some rebase?

With the updated 3rd patch. all patchset works on latest tip/sched/core.
Thanks for testing, Michael!

-- 
Thanks
    Alex
