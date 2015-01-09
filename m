Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbbAIPXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:23:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:23333 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902AbbAIPXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:23:46 -0500
X-AuditID: cbfee61a-f79c06d000004e71-94-54aff27fc7ee
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH/RFC v10 04/19] dt-binding: mfd: max77693: Add DT binding
 related macros
Date: Fri, 09 Jan 2015 16:22:54 +0100
Message-id: <1420816989-1808-5-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jQd36T+tDDA7ctLHYOGM9q8XRnROZ
	LK5/ec5qMf/IOVaL3qvPGS3ONr1ht7j/9SijxeVdc9gstr5Zx2jRs2Erq8XdU0fZLHbvespq
	cfhNO6vFmf0r2Rz4PHbOusvucfjrQhaPO9f2sHnsmf+D1aNvyypGjxWrv7N7fN4kF8AexWWT
	kpqTWZZapG+XwJVxdut69oLVnBWXXjxha2D8xd7FyMkhIWAisefACxYIW0ziwr31bF2MXBxC
	AtMZJW5PuMkGkhASaGeSOHgKzGYTMJT4+eI1UxcjB4eIQLTEpWP1IPXMApuYJN5dOMEMUiMs
	ECnxf9kmsHoWAVWJ5f/7GUFsXgF3icmnLjOC9EoIKEjMmWQDYnIKeEi0/HYCMYWAKt5cNZzA
	yLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnCgPpPawbiyweIQowAHoxIP7wa59SFC
	rIllxZW5hxglOJiVRHgbNgOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yrZt4UICaQnlqRmp6YW
	pBbBZJk4OKUaGG3NglJ/sTbo3el/8sxV/MYsL8No8SDF+ylrg2TXzFVctWcLs45N0/PM5mNd
	1SsY83tjpry2Ycz3qDszM2jF69MiikdYUy9Ynu549EjypauI4xS7X7/cmHJffT3V6bRr1vF2
	trqyqI9md2U6JhYoqyUnySmn370eXv/bXEgoan5nsKOrXoWrEktxRqKhFnNRcSIANJkv4lAC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add macros for max77693 led part related binding.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
---
 include/dt-bindings/mfd/max77693.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 include/dt-bindings/mfd/max77693.h

diff --git a/include/dt-bindings/mfd/max77693.h b/include/dt-bindings/mfd/max77693.h
new file mode 100644
index 0000000..f53e197
--- /dev/null
+++ b/include/dt-bindings/mfd/max77693.h
@@ -0,0 +1,21 @@
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
+/* External trigger type */
+#define MAX77693_LED_TRIG_TYPE_EDGE	0
+#define MAX77693_LED_TRIG_TYPE_LEVEL	1
+
+/* Boost modes */
+#define MAX77693_LED_BOOST_OFF		0
+#define MAX77693_LED_BOOST_ADAPTIVE	1
+#define MAX77693_LED_BOOST_FIXED	2
+
+#endif /* __DT_BINDINGS_MAX77693_H */
-- 
1.7.9.5

