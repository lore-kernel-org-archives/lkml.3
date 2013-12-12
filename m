Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3LLAMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:12:35 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:47076 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LLAMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:12:32 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v7 sched part 0/4] sched: numa: several fixups
Date: Thu, 12 Dec 2013 08:12:19 +0800
Message-Id: <1386807143-15994-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121200-5816-0000-0000-00000B4D4ABB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wanpeng Li (4):
  sched/numa: drop sysctl_numa_balancing_settle_count sysctl
  sched/numa: use wrapper function task_node to get node which task is on
  sched/numa: use wrapper function task_faults_idx to calculate index in group_faults
  sched/numa: fix period_slot recalculation

 include/linux/sched/sysctl.h |  1 -
 kernel/sched/debug.c         |  2 +-
 kernel/sched/fair.c          | 17 ++++-------------
 kernel/sysctl.c              |  7 -------
 4 files changed, 5 insertions(+), 22 deletions(-)

-- 
1.8.3.2

