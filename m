Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaCRI6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:58:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:13086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbaCRI5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:57:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,676,1389772800"; 
   d="scan'208";a="474739787"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 2/4] hrtimer: export __hrtimer_start_range_ns
Date: Tue, 18 Mar 2014 16:56:42 +0800
Message-Id: <1395133004-23205-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export __hrtimer_start_range_ns() to allow building perf Intel uncore
driver as module

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 kernel/hrtimer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0909436..650bf38 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1030,6 +1030,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__hrtimer_start_range_ns);
 
 /**
  * hrtimer_start_range_ns - (re)start an hrtimer on the current CPU
-- 
1.8.5.3

