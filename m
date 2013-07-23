Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab3GWQFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:05:16 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35838 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3GWQFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:05:13 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: imx-drm: Fix typo in staging/imx-drm
Date: Wed, 24 Jul 2013 01:05:07 +0900
Message-Id: <1374595507-26418-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.3.4.837.g0bde8c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in staging/imx-drm

Singed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/imx-drm/Kconfig   | 2 +-
 drivers/staging/imx-drm/imx-ldb.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
index 2233905..6156e3f 100644
--- a/drivers/staging/imx-drm/Kconfig
+++ b/drivers/staging/imx-drm/Kconfig
@@ -15,7 +15,7 @@ config DRM_IMX_FB_HELPER
 	help
 	  The DRM framework can provide a legacy /dev/fb0 framebuffer
 	  for your device. This is necessary to get a framebuffer console
-	  and also for appplications using the legacy framebuffer API
+	  and also for applications using the legacy framebuffer API
 
 config DRM_IMX_PARALLEL_DISPLAY
 	tristate "Support for parallel displays"
diff --git a/drivers/staging/imx-drm/imx-ldb.c b/drivers/staging/imx-drm/imx-ldb.c
index 8af7f3b..bb7da0e 100644
--- a/drivers/staging/imx-drm/imx-ldb.c
+++ b/drivers/staging/imx-drm/imx-ldb.c
@@ -497,7 +497,7 @@ static int imx_ldb_probe(struct platform_device *pdev)
 		imx_ldb->ldb_ctrl |= LDB_SPLIT_MODE_EN;
 
 	/*
-	 * There are three diferent possible clock mux configurations:
+	 * There are three different possible clock mux configurations:
 	 * i.MX53:  ipu1_di0_sel, ipu1_di1_sel
 	 * i.MX6q:  ipu1_di0_sel, ipu1_di1_sel, ipu2_di0_sel, ipu2_di1_sel
 	 * i.MX6dl: ipu1_di0_sel, ipu1_di1_sel, lcdif_sel
-- 
1.8.3.3.820.ge3d4493

