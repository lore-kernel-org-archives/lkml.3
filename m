Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3LPUVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:21:32 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:60844 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3LPUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:20:10 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        vincent.weaver@maine.edu, maria.n.dimakopoulou@gmail.com
Subject: [PATCH 1/2] perf/x86: enable Haswell Celeron RAPL support
Date: Mon, 16 Dec 2013 21:20:23 +0100
Message-Id: <1387225224-27799-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387225224-27799-1-git-send-email-eranian@google.com>
References: <1387225224-27799-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable RAPL support for Haswell Celeron (model 69).

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index bf8e4a7..0e3754e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -615,6 +615,7 @@ static int __init rapl_pmu_init(void)
 	case 42: /* Sandy Bridge */
 	case 58: /* Ivy Bridge */
 	case 60: /* Haswell */
+	case 69: /* Haswell-Celeron */
 		rapl_cntr_mask = RAPL_IDX_CLN;
 		rapl_pmu_events_group.attrs = rapl_events_cln_attr;
 		break;
-- 
1.7.9.5

