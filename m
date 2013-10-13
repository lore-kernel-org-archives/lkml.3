Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3JMWom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 18:44:42 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:61672 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3JMWoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 18:44:39 -0400
From: Roel Kluin <roel.kluin@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] set data enable logic level to low
Date: Mon, 14 Oct 2013 00:44:33 +0200
Message-Id: <1381704273-31540-1-git-send-email-roel.kluin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/video/omap2/dss/display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/omap2/dss/display.c b/drivers/video/omap2/dss/display.c
index fafe7c9..669a81f 100644
--- a/drivers/video/omap2/dss/display.c
+++ b/drivers/video/omap2/dss/display.c
@@ -266,7 +266,7 @@ void videomode_to_omap_video_timings(const struct videomode *vm,
 		OMAPDSS_SIG_ACTIVE_LOW;
 	ovt->de_level = vm->flags & DISPLAY_FLAGS_DE_HIGH ?
 		OMAPDSS_SIG_ACTIVE_HIGH :
-		OMAPDSS_SIG_ACTIVE_HIGH;
+		OMAPDSS_SIG_ACTIVE_LOW;
 	ovt->data_pclk_edge = vm->flags & DISPLAY_FLAGS_PIXDATA_POSEDGE ?
 		OMAPDSS_DRIVE_SIG_RISING_EDGE :
 		OMAPDSS_DRIVE_SIG_FALLING_EDGE;
-- 
1.8.1.2

