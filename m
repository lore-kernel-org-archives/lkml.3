Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaCRI5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:57:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:47471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbaCRI5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:57:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,676,1389772800"; 
   d="scan'208";a="474739805"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 3/4] perf/x86: export perf_assign_events
Date: Tue, 18 Mar 2014 16:56:43 +0800
Message-Id: <1395133004-23205-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export perf_assign_events to allow building perf Intel uncore driver
as module

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ae407f7..89f3b7c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -721,6 +721,7 @@ int perf_assign_events(struct perf_event **events, int n,
 
 	return sched.state.unassigned;
 }
+EXPORT_SYMBOL_GPL(perf_assign_events);
 
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
-- 
1.8.5.3

