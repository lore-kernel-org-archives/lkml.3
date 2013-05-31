Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3EaMZC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:25:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57572 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3EaMYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:24:55 -0400
Date: Fri, 31 May 2013 05:24:14 -0700
From: tip-bot for Sukadev Bhattiprolu <tipbot@zytor.com>
Message-ID: <tip-54aa3b99982a6e5f12b52b394244b5086a330a34@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, benh@kernel.crashing.org,
        tglx@linutronix.de, sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        benh@kernel.crashing.org, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com
In-Reply-To: <20130406170623.GA900@us.ibm.com>
References: <20130406170623.GA900@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Power7 Update testing ABI to list CPI-stack events
Git-Commit-ID: 54aa3b99982a6e5f12b52b394244b5086a330a34
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54aa3b99982a6e5f12b52b394244b5086a330a34
Gitweb:     http://git.kernel.org/tip/54aa3b99982a6e5f12b52b394244b5086a330a34
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Sat, 6 Apr 2013 09:52:05 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 16:09:42 +0300

perf: Power7 Update testing ABI to list CPI-stack events

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
 
