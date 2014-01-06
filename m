Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaAFMyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:54:25 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63396 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaAFMyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:54:23 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: [PATCH v2] Documentation: add ABI entry for intel_pstate
Date: Mon,  6 Jan 2014 18:24:26 +0530
Message-Id: <1389012866-29821-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1388997077-25138-1-git-send-email-artagnon@gmail.com>
References: <1388997077-25138-1-git-send-email-artagnon@gmail.com>
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
 Documentation/ABI/testing/sysfs-devices-system-cpu | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 468e4d4..d5a0d33 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -200,3 +200,27 @@ Description:	address and size of the percpu note.
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
+		max_perf_pct: limits the maximum P state that will be requested by
+		the driver stated as a percentage of the available performance.
+
+		min_perf_pct: limits the minimum P state that will be requested by
+		the driver stated as a percentage of the available performance.
+
+		no_turbo: limits the driver to selecting P states below the turbo
+		frequency range.
+
+		More details can be found in Documentation/cpu-freq/intel-pstate.txt
-- 
1.8.5.2.227.g53f3478

