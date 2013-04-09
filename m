Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3DIFJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 01:09:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:46511 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab3DIFJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 01:09:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,436,1363158000"; 
   d="scan'208";a="224884575"
Message-ID: <5163A25F.5080909@intel.com>
Date: Tue, 09 Apr 2013 13:08:47 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 11:23 AM, Alex Shi wrote:
> This version resolved the aim7 liked benchmark issue by patch 8th.
> Thanks for MikeG's avg_idle that is a good bursty wakeup indicator.
> 
> The first 3 patches were also include in my power aware scheduling patchset.
> 
> Morten, you can rebase your patch on this new version that bases on latest
> Linus tree. :)
> 
> a git tree for this patchset:
> 	https://github.com/alexshi/power-scheduling.git runnablelb

I removed the 3rd and 8th patches, left 1,2,4,5,6,7. and updated them in
above git tree.

I tested the kbuild, specjbb2005, aim9, fileio-cfq, hackbench and
dbench. on my NHM EP and 2 sockets SNB EP box. hackbench increased 3~5%
on both machines. kbuild has suspicious 2% increase. others has no clear
change.

Any more comments or concern about this patch?
> 
> Thanks
> Alex
> 
> [patch v3 1/8] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
> [patch v3 2/8] sched: set initial value of runnable avg for new
> [patch v3 3/8] sched: only count runnable avg on cfs_rq's nr_running
> [patch v3 4/8] sched: update cpu load after task_tick.
> [patch v3 5/8] sched: compute runnable load avg in cpu_load and
> [patch v3 6/8] sched: consider runnable load average in move_tasks
> [patch v3 7/8] sched: consider runnable load average in
> [patch v3 8/8] sched: use instant load for burst wake up
> 


-- 
Thanks Alex
