Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836Ab3E3QMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:12:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50985 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934591Ab3E3QCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 56/66] perf: Power7 Update testing ABI to list CPI-stack events
Date: Thu, 30 May 2013 19:01:29 +0300
Message-Id: <1369929699-8724-57-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Following patch added several Power7 events into /sys/devices/cpu/events.
Document those events in the testing ABI.

	https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-April/105167.html

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130406170623.GA900@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../testing/sysfs-bus-event_source-devices-events  | 32 ++++++++++++++++++----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
index 0adeb52..8b25ffb 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-events
@@ -27,14 +27,36 @@ Description:	Generic performance monitoring events
 		"basename".
 
 
-What: 		/sys/devices/cpu/events/PM_LD_MISS_L1
-		/sys/devices/cpu/events/PM_LD_REF_L1
-		/sys/devices/cpu/events/PM_CYC
+What: 		/sys/devices/cpu/events/PM_1PLUS_PPC_CMPL
 		/sys/devices/cpu/events/PM_BRU_FIN
-		/sys/devices/cpu/events/PM_GCT_NOSLOT_CYC
 		/sys/devices/cpu/events/PM_BRU_MPRED
-		/sys/devices/cpu/events/PM_INST_CMPL
 		/sys/devices/cpu/events/PM_CMPLU_STALL
+		/sys/devices/cpu/events/PM_CMPLU_STALL_BRU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_DCACHE_MISS
+		/sys/devices/cpu/events/PM_CMPLU_STALL_DFU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_DIV
+		/sys/devices/cpu/events/PM_CMPLU_STALL_ERAT_MISS
+		/sys/devices/cpu/events/PM_CMPLU_STALL_FXU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_IFU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_LSU
+		/sys/devices/cpu/events/PM_CMPLU_STALL_REJECT
+		/sys/devices/cpu/events/PM_CMPLU_STALL_SCALAR
+		/sys/devices/cpu/events/PM_CMPLU_STALL_SCALAR_LONG
+		/sys/devices/cpu/events/PM_CMPLU_STALL_STORE
+		/sys/devices/cpu/events/PM_CMPLU_STALL_THRD
+		/sys/devices/cpu/events/PM_CMPLU_STALL_VECTOR
+		/sys/devices/cpu/events/PM_CMPLU_STALL_VECTOR_LONG
+		/sys/devices/cpu/events/PM_CYC
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_BR_MPRED
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_BR_MPRED_IC_MISS
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_CYC
+		/sys/devices/cpu/events/PM_GCT_NOSLOT_IC_MISS
+		/sys/devices/cpu/events/PM_GRP_CMPL
+		/sys/devices/cpu/events/PM_INST_CMPL
+		/sys/devices/cpu/events/PM_LD_MISS_L1
+		/sys/devices/cpu/events/PM_LD_REF_L1
+		/sys/devices/cpu/events/PM_RUN_CYC
+		/sys/devices/cpu/events/PM_RUN_INST_CMPL
 
 Date:		2013/01/08
 
-- 
1.8.1.4

