Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3ARLlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:41:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59481 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3ARLlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:41:07 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: linux-watchdog@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/4] mfd: dbx500-prcmu: add watchdog ID definitions
Date: Fri, 18 Jan 2013 12:40:11 +0100
Message-Id: <1358509214-22407-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
References: <1358509214-22407-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add definition of watchdog IDs to be used by ux500_wdt driver.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 include/linux/mfd/dbx500-prcmu.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index c202d6c..c6e0608 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -147,6 +147,18 @@ enum prcmu_clock {
 };
 
 /**
+ * enum prcmu_wdog_id - PRCMU watchdog IDs
+ * @PRCMU_WDOG_ALL: use all timers
+ * @PRCMU_WDOG_CPU1: use first CPU timer only
+ * @PRCMU_WDOG_CPU2: use second CPU timer conly
+ */
+enum prcmu_wdog_id {
+	PRCMU_WDOG_ALL = 0x00,
+	PRCMU_WDOG_CPU1 = 0x01,
+	PRCMU_WDOG_CPU2 = 0x02,
+};
+
+/**
  * enum ape_opp - APE OPP states definition
  * @APE_OPP_INIT:
  * @APE_NO_CHANGE: The APE operating point is unchanged
-- 
1.7.12.1

