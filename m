Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaJ0JtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:49:05 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8645 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaJ0JtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:49:00 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-32-544e150acaf0
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Thierry Reding <treding@nvidia.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/5] MAINTAINERS: Add entry for Exynos MIPI DSI DRM driver
Date: Mon, 27 Oct 2014 10:48:29 +0100
Message-id: <1414403310-6316-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
References: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t/xq7pcon4hBq/nm1jcWneO1eLK1/ds
	FpPuT2CxuLxrDpvF7d98Dqwe97uPM3n0Nr9j8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	p/9vMxb8YqnY03aUuYFxGksXIyeHhICJxIELM9ghbDGJC/fWs3UxcnEICSxllHh5/S8TSEJI
	oI9JYtauYhCbTUBT4u/mm2wgtoiAssTfiasYQRqYBWYySmz9cpm1i5GDQ1jAS2L+oTqQGhYB
	VYnfe3aALeMVcJLo2dcOtUxO4uSxyawgNqeAs8Tfqd/ZIHY5SRz/eI5lAiPvAkaGVYyiqaXJ
	BcVJ6blGesWJucWleel6yfm5mxghQfN1B+PSY1aHGAU4GJV4eCcU+4YIsSaWFVfmHmKU4GBW
	EuF1/AkU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMh17bzR/hfc1wTKWS3n158rXOUrZHVL3zGu
	dOOSpkqXEyXSzw+XSrYJzL3i2XH+/pOTgj8sL7/X/nLY6Sv/oXdmlyboWMhfycnqtOEK2+e6
	kkPDgI+f5YbUdKH7LAdOftq0YvaV2do/p0bcXLQr0+NFRMTEhth9Gx51tDhy//AMubRZ2PsX
	h5ISS3FGoqEWc1FxIgBnnpnP+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2546fca..256183e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3650,6 +3650,12 @@ S:	Maintained
 F:	drivers/video/fbdev/exynos/exynos_mipi*
 F:	include/video/exynos_mipi*
 
+EXYNOS MIPI DSI DRM DRIVER
+M:	Andrzej Hajda <a.hajda@samsung.com>
+L:	dri-devel@lists.freedesktop.org
+S:	Supported
+F:	drivers/gpu/drm/exynos/exynos_drm_dsi.c
+
 F71805F HARDWARE MONITORING DRIVER
 M:	Jean Delvare <jdelvare@suse.de>
 L:	lm-sensors@lm-sensors.org
-- 
1.9.1

