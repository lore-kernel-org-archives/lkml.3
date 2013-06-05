Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab3FEIab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:30:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:2107 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab3FEIa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,804,1363158000"; 
   d="scan'208";a="324502737"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, a.p.zijlstra@chello.nl,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86/intel: Fix sparse warning
Date: Wed,  5 Jun 2013 16:30:25 +0800
Message-Id: <1370421025-10986-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 52441a2..422afe0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -536,7 +536,7 @@ __snbep_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *eve
 	if (!uncore_box_is_fake(box))
 		reg1->alloc |= alloc;
 
-	return 0;
+	return NULL;
 fail:
 	for (; i >= 0; i--) {
 		if (alloc & (0x1 << i))
-- 
1.8.1.4

