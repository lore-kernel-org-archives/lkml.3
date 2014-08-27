Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364AbaH0VJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:09:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:43417 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933809AbaH0VJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:09:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,413,1406617200"; 
   d="scan'208";a="590800781"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5] perf, x86: Document all Haswell models
Date: Wed, 27 Aug 2014 14:03:54 -0700
Message-Id: <1409173437-3041-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409173437-3041-1-git-send-email-andi@firstfloor.org>
References: <1409173437-3041-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add names for each Haswell model as requested by Peter.

v2: Remove Crystall Well name.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f962e26..71caf22 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2540,10 +2540,10 @@ __init int intel_pmu_init(void)
 		break;
 
 
-	case 60: /* 22nm Haswell */
-	case 63:
-	case 69:
-	case 70:
+	case 60: /* 22nm Haswell Client */
+	case 63: /* 22nm Haswell Server */
+	case 69: /* 22nm Haswell ULT */
+	case 70: /* 22nm Haswell Client */
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
-- 
1.9.3

