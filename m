Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbbAFMpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:45:18 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55656 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbAFMpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:45:16 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: vt8500lcdfb: remove unneeded continue
Date: Tue,  6 Jan 2015 18:15:01 +0530
Message-Id: <1420548302-11489-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

continue is not needed at the end of a for loop

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/video/fbdev/vt8500lcdfb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/vt8500lcdfb.c b/drivers/video/fbdev/vt8500lcdfb.c
index ffaf29e..6716bf5 100644
--- a/drivers/video/fbdev/vt8500lcdfb.c
+++ b/drivers/video/fbdev/vt8500lcdfb.c
@@ -115,7 +115,6 @@ static int vt8500lcd_set_par(struct fb_info *info)
 	for (i = 0; i < 8; i++) {
 		if (bpp_values[i] == info->var.bits_per_pixel) {
 			reg_bpp = i;
-			continue;
 		}
 	}
 
-- 
1.8.1.2

