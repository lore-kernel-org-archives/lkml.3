Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaGKQOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:14:50 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:60571 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaGKQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:13:37 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jiri Kosina <trivial@kernel.org>, linux-fbdev@vger.kernel.org
Subject: [PATCH v2 trivial 5/6] video: mx3fb: Update comment for dmaengine_prep_slave_sg() API
Date: Fri, 11 Jul 2014 18:13:27 +0200
Message-Id: <1405095208-14642-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
References: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave:
introduce inline wrappers") changed the code to use the new API, but forgot
to update a comment.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-fbdev@vger.kernel.org
--
v2:
  - New
---
 drivers/video/fbdev/mx3fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/mx3fb.c b/drivers/video/fbdev/mx3fb.c
index c645a0a0c341..5e97baf92721 100644
--- a/drivers/video/fbdev/mx3fb.c
+++ b/drivers/video/fbdev/mx3fb.c
@@ -1179,7 +1179,7 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 
 	/*
 	 * We enable the End of Frame interrupt, which will free a tx-descriptor,
-	 * which we will need for the next device_prep_slave_sg(). The
+	 * which we will need for the next dmaengine_prep_slave_sg(). The
 	 * IRQ-handler will disable the IRQ again.
 	 */
 	init_completion(&mx3_fbi->flip_cmpl);
-- 
1.9.1

