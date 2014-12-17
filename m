Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaLQQpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:45:47 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:56870 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaLQQpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:45:44 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        linux@roeck-us.net, arnd@arndb.de
Subject: [PATCH 1/8] mfd: dt-bindings: Provide human readable defines for LPC mode choosing
Date: Wed, 17 Dec 2014 16:45:20 +0000
Message-Id: <1418834727-1602-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418834727-1602-1-git-send-email-lee.jones@linaro.org>
References: <1418834727-1602-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST's Low Power Controller can currently operate in two supported modes;
Watchdog and Real Time Clock.  These defines will aid engineers to easily
identify the selected mode.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/dt-bindings/mfd/st-lpc.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 include/dt-bindings/mfd/st-lpc.h

diff --git a/include/dt-bindings/mfd/st-lpc.h b/include/dt-bindings/mfd/st-lpc.h
new file mode 100644
index 0000000..e3e6c75
--- /dev/null
+++ b/include/dt-bindings/mfd/st-lpc.h
@@ -0,0 +1,15 @@
+/*
+ * This header provides shared DT/Driver defines for ST's LPC device
+ *
+ * Copyright (C) 2014 STMicroelectronics -- All Rights Reserved
+ *
+ * Author: Lee Jones <lee.jones@linaro.org> for STMicroelectronics
+ */
+
+#ifndef __DT_BINDINGS_ST_LPC_H__
+#define __DT_BINDINGS_ST_LPC_H__
+
+#define ST_LPC_MODE_RTC		0
+#define ST_LPC_MODE_WDT		1
+
+#endif /* __DT_BINDINGS_ST_LPC_H__ */
-- 
1.9.1

