Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947628Ab3BIBLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:11:50 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:37870 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947601Ab3BIBIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:41 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 07/16] ACPI / idle : remove pointless headers
Date: Fri,  8 Feb 2013 20:08:11 -0500
Message-Id: <e2668fb53ffd3e01c3116f65a9047a25e4c66399.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

These different headers are not needed.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 5cb5f24..82626e9 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -28,19 +28,12 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/cpufreq.h>
-#include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/dmi.h>
-#include <linux/moduleparam.h>
-#include <linux/sched.h>	/* need_resched() */
-#include <linux/pm_qos.h>
+#include <linux/sched.h>       /* need_resched() */
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
-#include <linux/irqflags.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines
@@ -52,12 +45,8 @@
 #include <asm/apic.h>
 #endif
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
-
 #include <acpi/acpi_bus.h>
 #include <acpi/processor.h>
-#include <asm/processor.h>
 
 #define PREFIX "ACPI: "
 
-- 
1.8.1.3.535.ga923c31

