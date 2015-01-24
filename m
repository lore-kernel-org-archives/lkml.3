Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbbAXCph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 21:45:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:54204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbbAXCpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 21:45:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,457,1418112000"; 
   d="scan'208";a="655783572"
Date: Sat, 24 Jan 2015 10:44:57 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: kbuild-all@01.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [clk:test-sched-packing-tasks-freq 10820/10847]
 kernel/sched/fair.c:199:1: sparse: symbol '__pcpu_scope_sd_pack_buddy' was
 not declared. Should it be static?
Message-ID: <201501241041.Cc4XnwuN%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   https://git.linaro.org/people/mturquette/linux.git test-sched-packing-tasks-freq
head:   3add111981928a9ce810cd1b1956dc39e6c2445f
commit: 9cb183281a03911e724a648832d9f096c09197fe [10820/10847] sched: packing tasks
reproduce:
  # apt-get install sparse
  git checkout 9cb183281a03911e724a648832d9f096c09197fe
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   kernel/sched/fair.c:51:14: sparse: symbol 'normalized_sysctl_sched_latency' was not declared. Should it be static?
   kernel/sched/fair.c:70:14: sparse: symbol 'normalized_sysctl_sched_min_granularity' was not declared. Should it be static?
   kernel/sched/fair.c:92:14: sparse: symbol 'normalized_sysctl_sched_wakeup_granularity' was not declared. Should it be static?
>> kernel/sched/fair.c:199:1: sparse: symbol '__pcpu_scope_sd_pack_buddy' was not declared. Should it be static?
   kernel/sched/sched.h:765:9: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:249:22: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:4993:14: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:1666:14: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:2168:15: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:7571:22: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:7586:9: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:5070:9: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:5126:17: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:5706:41: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:5742:41: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:7688:9: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:7755:17: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:7839:14: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:7727:16: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:7921:9: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:7727:16: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:7822:14: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:8091:14: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:8103:14: sparse: incompatible types in comparison expression (different address spaces)
   kernel/sched/fair.c:8112:14: sparse: incompatible types in comparison expression (different address spaces)

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
