Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaAFIbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:31:16 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41689 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaAFIbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:31:14 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: [PATCH] Documentation: add ABI entry for intel_pstate
Date: Mon,  6 Jan 2014 14:01:17 +0530
Message-Id: <1388997077-25138-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a Documentation/ABI entry for
/sys/devices/system/cpu/intel_pstate/max_perf_pct,
/sys/devices/system/cpu/intel_pstate/min_perf_pct, and
/sys/devices/system/cpu/intel_pstate/no_turbo.

Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux PM <linux-pm@vger.kernel.org>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 468e4d4..7080718 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -200,3 +200,18 @@ Description:	address and size of the percpu note.
 		note of cpu#.
 
 		crash_notes_size: size of the note of cpu#.
+
+
+What:		/sys/devices/system/cpu/intel_pstate/max_perf_pct
+		/sys/devices/system/cpu/intel_pstate/min_perf_pct
+		/sys/devices/system/cpu/intel_pstate/no_turbo
+Date:		February 2013
+Contact:	linux-pm@vger.kernel.org
+Description:	Parameters for the Intel P-state driver
+
+		Logic for selecting the current P-state in Intel
+		Sandybridge+ processors. The three knobs control
+		limits for the P-state that will be requested by the
+		driver.
+
+		More details can be found in Documentation/cpu-freq/intel-pstate.txt
-- 
1.8.5.2.227.g53f3478

