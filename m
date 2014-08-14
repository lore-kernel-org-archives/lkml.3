Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaHNBSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:18:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:62362 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaHNBR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:17:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,859,1400050800"; 
   d="scan'208";a="558285887"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] perf, x86: Remove incorrect model number from Haswell perf
Date: Wed, 13 Aug 2014 18:17:45 -0700
Message-Id: <1407979069-7121-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 2502d0d..ef6c8b7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2541,7 +2541,6 @@ __init int intel_pmu_init(void)
 
 	case 60: /* Haswell Client */
 	case 70:
-	case 71:
 	case 63:
 	case 69:
 		x86_pmu.late_ack = true;
-- 
1.9.3

