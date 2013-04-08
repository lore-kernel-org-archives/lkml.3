Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696Ab3DHBrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 21:47:37 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:47352 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934638Ab3DHBrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 21:47:36 -0400
From: Tyrel Datwyler <turtle.on.the.radio@gmail.com>
To: gregkh@linuxfoundation.org, eduardo.falentin@ti.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tyrel Datwyler <turtle.on.the.radio@gmail.com>
Subject: [PATCH] Staging: omap-thermal: remove trailing whitespace from omap-bandgap.c
Date: Sun,  7 Apr 2013 18:47:20 -0700
Message-Id: <1365385640-10443-1-git-send-email-turtle.on.the.radio@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes trailing whitespace from a blank line in omap-bandgap.c as
detected by the checkpatch.pl tool.

Signed-off-by: Tyrel Datwyler <turtle.on.the.radio@gmail.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index dcc1448..e507d17 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -823,7 +823,7 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 			bg_ptr->base = chunk;
 		if (IS_ERR(chunk))
 			return ERR_CAST(chunk);
-		
+
 		i++;
 	} while (res);
 
-- 
1.8.1.4

