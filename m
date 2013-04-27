Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3D0SGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 14:06:35 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33471 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3D0SGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 14:06:34 -0400
From: jaswinder.singh@linaro.org
To: s-anna@ti.com, loic.pallardy@st.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, andy.green@linaro.org,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 1/3] mailbox: rename pl320-ipc specific mailbox.h
Date: Sat, 27 Apr 2013 23:35:53 +0530
Message-Id: <1367085953-28270-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
References: <CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

The patch 30058677 "ARM / highbank: add support for pl320 IPC"
added a pl320 IPC specific header file as a generic mailbox.h.
This file has been renamed appropriately to allow the
introduction of the generic mailbox API framework.

Signed-off-by: Suman Anna <s-anna@ti.com>
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/cpufreq/highbank-cpufreq.c       |    2 +-
 drivers/mailbox/pl320-ipc.c              |    2 +-
 include/linux/{mailbox.h => pl320-ipc.h} |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename include/linux/{mailbox.h => pl320-ipc.h} (100%)

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index b61b5a3..3118b87 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -19,7 +19,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/of.h>
-#include <linux/mailbox.h>
+#include <linux/pl320-ipc.h>
 #include <linux/platform_device.h>
 
 #define HB_CPUFREQ_CHANGE_NOTE	0x80000001
diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
index d873cba..f3755e0 100644
--- a/drivers/mailbox/pl320-ipc.c
+++ b/drivers/mailbox/pl320-ipc.c
@@ -26,7 +26,7 @@
 #include <linux/device.h>
 #include <linux/amba/bus.h>
 
-#include <linux/mailbox.h>
+#include <linux/pl320-ipc.h>
 
 #define IPCMxSOURCE(m)		((m) * 0x40)
 #define IPCMxDSET(m)		(((m) * 0x40) + 0x004)
diff --git a/include/linux/mailbox.h b/include/linux/pl320-ipc.h
similarity index 100%
rename from include/linux/mailbox.h
rename to include/linux/pl320-ipc.h
-- 
1.7.10.4

