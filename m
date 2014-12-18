Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaLRQvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:51:53 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:41569 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbaLRQvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:51:49 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: Julian Brost <linux-kernel@0x4a42.net>,
        Fabian Hofmann <fabian.hofmann@fau.de>
Cc: linux-kernel@i4.cs.fau.de, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] perf/x86/intel/uncore: coding style: Fix alignment in macros
Date: Thu, 18 Dec 2014 17:51:38 +0100
Message-Id: <1418921500-5630-4-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
References: <1418751050-11725-1-git-send-email-linux-kernel@0x4a42.net>
 <1418921500-5630-1-git-send-email-linux-kernel@0x4a42.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro definitions were improperly aligned which is fixed by this patch.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>
---
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index d817c43..7f457da 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -114,7 +114,7 @@
 /* IVBEP event control */
 #define IVBEP_PMON_BOX_CTL_INT		(SNBEP_PMON_BOX_CTL_RST_CTRL | \
 					 SNBEP_PMON_BOX_CTL_RST_CTRS)
-#define IVBEP_PMON_RAW_EVENT_MASK		(SNBEP_PMON_CTL_EV_SEL_MASK | \
+#define IVBEP_PMON_RAW_EVENT_MASK	(SNBEP_PMON_CTL_EV_SEL_MASK | \
 					 SNBEP_PMON_CTL_UMASK_MASK | \
 					 SNBEP_PMON_CTL_EDGE_DET | \
 					 SNBEP_PMON_CTL_TRESH_MASK)
@@ -129,16 +129,16 @@
 				 SNBEP_PMON_CTL_EDGE_DET | \
 				 SNBEP_U_MSR_PMON_CTL_TRESH_MASK)
 /* IVBEP Cbo */
-#define IVBEP_CBO_MSR_PMON_RAW_EVENT_MASK		(IVBEP_PMON_RAW_EVENT_MASK | \
+#define IVBEP_CBO_MSR_PMON_RAW_EVENT_MASK	(IVBEP_PMON_RAW_EVENT_MASK | \
 						 SNBEP_CBO_PMON_CTL_TID_EN)
 
-#define IVBEP_CB0_MSR_PMON_BOX_FILTER_TID		(0x1fULL << 0)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_TID	(0x1fULL << 0)
 #define IVBEP_CB0_MSR_PMON_BOX_FILTER_LINK	(0xfULL << 5)
 #define IVBEP_CB0_MSR_PMON_BOX_FILTER_STATE	(0x3fULL << 17)
-#define IVBEP_CB0_MSR_PMON_BOX_FILTER_NID		(0xffffULL << 32)
-#define IVBEP_CB0_MSR_PMON_BOX_FILTER_OPC		(0x1ffULL << 52)
-#define IVBEP_CB0_MSR_PMON_BOX_FILTER_C6		(0x1ULL << 61)
-#define IVBEP_CB0_MSR_PMON_BOX_FILTER_NC		(0x1ULL << 62)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_NID	(0xffffULL << 32)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_OPC	(0x1ffULL << 52)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_C6	(0x1ULL << 61)
+#define IVBEP_CB0_MSR_PMON_BOX_FILTER_NC	(0x1ULL << 62)
 #define IVBEP_CB0_MSR_PMON_BOX_FILTER_ISOC	(0x1ULL << 63)
 
 /* IVBEP home agent */
@@ -185,20 +185,20 @@
 #define HSWEP_CBO_MSR_OFFSET			0x10
 
 
-#define HSWEP_CB0_MSR_PMON_BOX_FILTER_TID		(0x3fULL << 0)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_TID	(0x3fULL << 0)
 #define HSWEP_CB0_MSR_PMON_BOX_FILTER_LINK	(0xfULL << 6)
 #define HSWEP_CB0_MSR_PMON_BOX_FILTER_STATE	(0x7fULL << 17)
-#define HSWEP_CB0_MSR_PMON_BOX_FILTER_NID		(0xffffULL << 32)
-#define HSWEP_CB0_MSR_PMON_BOX_FILTER_OPC		(0x1ffULL << 52)
-#define HSWEP_CB0_MSR_PMON_BOX_FILTER_C6		(0x1ULL << 61)
-#define HSWEP_CB0_MSR_PMON_BOX_FILTER_NC		(0x1ULL << 62)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_NID	(0xffffULL << 32)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_OPC	(0x1ffULL << 52)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_C6	(0x1ULL << 61)
+#define HSWEP_CB0_MSR_PMON_BOX_FILTER_NC	(0x1ULL << 62)
 #define HSWEP_CB0_MSR_PMON_BOX_FILTER_ISOC	(0x1ULL << 63)
 
 
 /* Haswell-EP Sbox */
 #define HSWEP_S0_MSR_PMON_CTR0			0x726
 #define HSWEP_S0_MSR_PMON_CTL0			0x721
-#define HSWEP_S0_MSR_PMON_BOX_CTL			0x720
+#define HSWEP_S0_MSR_PMON_BOX_CTL		0x720
 #define HSWEP_SBOX_MSR_OFFSET			0xa
 #define HSWEP_S_MSR_PMON_RAW_EVENT_MASK		(SNBEP_PMON_RAW_EVENT_MASK | \
 						 SNBEP_CBO_PMON_CTL_TID_EN)
-- 
1.9.1

