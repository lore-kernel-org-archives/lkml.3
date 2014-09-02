Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaIBSo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:44:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:2412 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbaIBSo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,450,1406617200"; 
   d="scan'208";a="474704645"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5] perf, x86: Document all Haswell models
Date: Tue,  2 Sep 2014 11:44:12 -0700
Message-Id: <1409683455-29168-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
References: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add names for each Haswell model as requested by Peter.

v2: Remove Crystall Well name.
v3: Change names
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f962e26..7c9f78e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2540,10 +2540,10 @@ __init int intel_pmu_init(void)
 		break;
 
 
-	case 60: /* 22nm Haswell */
-	case 63:
-	case 69:
-	case 70:
+	case 60: /* 22nm Haswell Core */
+	case 63: /* 22nm Haswell Server */
+	case 69: /* 22nm Haswell ULT */
+	case 70: /* 22nm Haswell + GT3e (Intel Iris Pro graphics) */
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
-- 
1.9.3

