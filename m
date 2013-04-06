Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3DFRHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 13:07:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50377 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3DFRHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 13:07:21 -0400
Date: Sat, 6 Apr 2013 10:06:24 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Power7 Update testing ABI to list CPI-stack events
Message-ID: <20130406170623.GA900@us.ibm.com>
References: <20130406164803.GA408@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406164803.GA408@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040617-7282-0000-0000-000015F4D599
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 03a785f9d19249d2e524f31d8ead539f15d28a9f Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Sat, 6 Apr 2013 09:52:05 -0700
Subject: [PATCH] perf: Power7 Update testing ABI to list CPI-stack events

Following patch added several Power7 events into /sys/devices/cpu/events.
Document those events in the testing ABI.

	https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-April/105167.html

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 .../testing/sysfs-bus-event_source-devices-events  |   32 ++++++++++++++++---
 1 files changed, 27 insertions(+), 5 deletions(-)

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
1.7.1

