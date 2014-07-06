Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaGFR6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:58:23 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35130 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaGFR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:58:22 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Archit Taneja <archit@ti.com>, Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: omap2: dss: sdi.c:  Cleaning up removal variable thet is never used
Date: Sun,  6 Jul 2014 19:59:37 +0200
Message-Id: <1404669577-15942-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of struct member variable thet is never used

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/omap2/dss/sdi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/dss/sdi.c b/drivers/video/fbdev/omap2/dss/sdi.c
index 911dcc9..c6491ac 100644
--- a/drivers/video/fbdev/omap2/dss/sdi.c
+++ b/drivers/video/fbdev/omap2/dss/sdi.c
@@ -34,7 +34,6 @@
 static struct {
 	struct platform_device *pdev;
 
-	bool update_enabled;
 	struct regulator *vdds_sdi_reg;
 
 	struct dss_lcd_mgr_config mgr_config;
-- 
1.7.10.4

