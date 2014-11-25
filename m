Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaKYIyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:54:54 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:42558 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKYIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:54:52 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>
CC: <m.chehab@samsung.com>, <linux-kernel@vger.kernel.org>,
        <g.liakhovetski@gmx.de>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 1/2] media: v4l2-image-sizes.h: add SVGA, XGA and UXGA size definitions
Date: Tue, 25 Nov 2014 16:54:27 +0800
Message-ID: <1416905668-23029-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SVGA, UXGA and XGA size definitions to v4l2-image-sizes.h.
The definitions are sorted by alphabet order.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 include/media/v4l2-image-sizes.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/media/v4l2-image-sizes.h b/include/media/v4l2-image-sizes.h
index 10daf92..c70c917 100644
--- a/include/media/v4l2-image-sizes.h
+++ b/include/media/v4l2-image-sizes.h
@@ -25,10 +25,19 @@
 #define QVGA_WIDTH	320
 #define QVGA_HEIGHT	240
 
+#define SVGA_WIDTH	800
+#define SVGA_HEIGHT	680
+
 #define SXGA_WIDTH	1280
 #define SXGA_HEIGHT	1024
 
 #define VGA_WIDTH	640
 #define VGA_HEIGHT	480
 
+#define UXGA_WIDTH	1600
+#define UXGA_HEIGHT	1200
+
+#define XGA_WIDTH	1024
+#define XGA_HEIGHT	768
+
 #endif /* _IMAGE_SIZES_H */
-- 
1.9.1

