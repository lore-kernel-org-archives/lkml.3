Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966983Ab3HIA02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:26:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:15815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966939Ab3HIA01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:26:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,842,1367996400"; 
   d="scan'208";a="359955779"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Add Haswell ULT model number used in Macbook Air
Date: Thu,  8 Aug 2013 17:26:23 -0700
Message-Id: <1376007983-31616-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This one was missed earlier.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 269c71d..4e99a80 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2367,6 +2367,7 @@ __init int intel_pmu_init(void)
 	case 70:
 	case 71:
 	case 63:
+	case 69:
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
-- 
1.8.3.1

