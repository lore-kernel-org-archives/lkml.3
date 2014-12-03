Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaLCQIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:08:02 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45443 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbaLCQH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:07:59 -0500
X-AuditID: cbfee61a-f79c06d000004e71-79-547f355c4d13
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH/RFC v9 07/19] dt-binding: mfd: max77693: Add DT binding related
 macros
Date: Wed, 03 Dec 2014 17:06:42 +0100
Message-id: <1417622814-10845-8-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQd0Y0/oQgysHrSw2zljPanF050Qm
	i+tfnrNa9L9ZyGpx7tVKRoveq88ZLc42vWG3uP/1KKPF5V1z2Cy2vlnHaNGzYSurxdLrF5ks
	7p46ymYxYfpaFovWvUfYLXbvespqcfhNO6vFmf0r2RyEPNbMW8Pocbmvl8lj56y77B4rl39h
	8zj8dSGLx6ZVnWwed67tYfPYM/8Hq0ffllWMHitWf2f3+LxJLoA7issmJTUnsyy1SN8ugStj
	TVNMwQreimvbHBsYF3J3MXJySAiYSDQ9ncsMYYtJXLi3nq2LkYtDSGA6o8TevYtYIZx2Jond
	x9eCVbEJGEr8fPGaqYuRg0NEIFri0rF6kBpmgW5mie7mPawgcWGBCInra8EWsAioShy4cYsJ
	xOYV8JC40/SFEaREQkBBYs4kG5Awp4CnxNMf99lBwkJAJQcn+k9g5F3AyLCKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIzjsn0ntYFzZYHGIUYCDUYmH1yKuLkSINbGsuDL3EKMEB7OSCO+z
	b0Ah3pTEyqrUovz4otKc1OJDjNIcLErivDdu5oYICaQnlqRmp6YWpBbBZJk4OKUaGA3e3S/a
	q8h+fmvsnxfeMcxtL1P4S7M6jlZ0fKg56J17yCnvq3p+0K7Zq66dvJ90NfRbapigwfyeq8YO
	q7OvZ98Lvtxdc/jxfq0NLytsbCNqXjLv8mAKsg/XDX2d9tW4IErtcnL+wpIlQnxtJavL/5tP
	XdkxKb1aUoixUJ6tcP+3N9PV7ALqlFiKMxINtZiLihMBgeb0W3cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add macros for max77693 led part related binding.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
---
 include/dt-bindings/mfd/max77693.h |   38 ++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 include/dt-bindings/mfd/max77693.h

diff --git a/include/dt-bindings/mfd/max77693.h b/include/dt-bindings/mfd/max77693.h
new file mode 100644
index 0000000..4011cb47
--- /dev/null
+++ b/include/dt-bindings/mfd/max77693.h
@@ -0,0 +1,38 @@
+/*
+ * This header provides macros for MAX77693 device binding
+ *
+ * Copyright (C) 2014, Samsung Electronics Co., Ltd.
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ */
+
+#ifndef __DT_BINDINGS_MAX77693_H__
+#define __DT_BINDINGS_MAX77693_H
+
+/* External control pins */
+#define MAX77693_LED_FLED_UNUSED	0
+#define MAX77693_LED_FLED_USED		1
+
+/* FLED pins */
+#define MAX77693_LED_FLED1		1
+#define MAX77693_LED_FLED2		2
+
+/* External trigger type */
+#define MAX77693_LED_TRIG_TYPE_EDGE	0
+#define MAX77693_LED_TRIG_TYPE_LEVEL	1
+
+/* Trigger flags */
+#define MAX77693_LED_TRIG_FLASHEN	(1 << 0)
+#define MAX77693_LED_TRIG_TORCHEN	(1 << 1)
+#define MAX77693_LED_TRIG_SOFTWARE	(1 << 2)
+
+#define MAX77693_LED_TRIG_ALL		(MAX77693_LED_TRIG_FLASHEN | \
+					 MAX77693_LED_TRIG_TORCHEN | \
+					 MAX77693_LED_TRIG_SOFTWARE)
+
+/* Boost modes */
+#define MAX77693_LED_BOOST_OFF		0
+#define MAX77693_LED_BOOST_ADAPTIVE	1
+#define MAX77693_LED_BOOST_FIXED	2
+
+#endif /* __DT_BINDINGS_MAX77693_H */
-- 
1.7.9.5

