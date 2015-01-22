Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbbAVTin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:38:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:57571 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbbAVTik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:38:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="443857410"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 1/1] perf/x86/intel: Add model number for Airmont
Date: Thu, 22 Jan 2015 07:50:53 +0000
Message-Id: <1421913053-99803-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Airmont supports the same architectural and non-architectural
performance monitoring events as Silvermont.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 944bf01..498b6d9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2431,6 +2431,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 55: /* 22nm Atom "Silvermont"                */
+	case 76: /* 14nm Atom "Airmont"                   */
 	case 77: /* 22nm Atom "Silvermont Avoton/Rangely" */
 		memcpy(hw_cache_event_ids, slm_hw_cache_event_ids,
 			sizeof(hw_cache_event_ids));
-- 
1.7.11.7

