Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab3DBDYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:24:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:14650 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759583Ab3DBDYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:24:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,391,1363158000"; 
   d="scan'208";a="310928464"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v3 0/8] sched: use runnable avg in load balance
Date: Tue,  2 Apr 2013 11:23:20 +0800
Message-Id: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version resolved the aim7 liked benchmark issue by patch 8th.
Thanks for MikeG's avg_idle that is a good bursty wakeup indicator.

The first 3 patches were also include in my power aware scheduling patchset.

Morten, you can rebase your patch on this new version that bases on latest
Linus tree. :)

a git tree for this patchset:
	https://github.com/alexshi/power-scheduling.git runnablelb

Thanks
Alex

[patch v3 1/8] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
[patch v3 2/8] sched: set initial value of runnable avg for new
[patch v3 3/8] sched: only count runnable avg on cfs_rq's nr_running
[patch v3 4/8] sched: update cpu load after task_tick.
[patch v3 5/8] sched: compute runnable load avg in cpu_load and
[patch v3 6/8] sched: consider runnable load average in move_tasks
[patch v3 7/8] sched: consider runnable load average in
[patch v3 8/8] sched: use instant load for burst wake up
