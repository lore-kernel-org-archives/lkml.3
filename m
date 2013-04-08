Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588Ab3DHRZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:25:52 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:55399 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3DHRZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:25:51 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, inki.dae@samsung.com,
        jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, dri-devel@lists.freedesktop.org
Cc: joe@perches.com, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] drm:exynos: Fix messages in exynos_drm_gsc.c
Date: Tue,  9 Apr 2013 02:25:43 +0900
Message-Id: <1365441943-26534-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2.451.gbfd70c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is better to remove "occured" from messages.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 7841c3b..898b307 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1314,13 +1314,13 @@ static irqreturn_t gsc_irq_handler(int irq, void *dev_id)
 
 	status = gsc_read(GSC_IRQ);
 	if (status & GSC_IRQ_STATUS_OR_IRQ) {
-		dev_err(ippdrv->dev, "occured overflow at %d, status 0x%x.\n",
+		dev_err(ippdrv->dev, "overflow at %d, status 0x%x.\n",
 			ctx->id, status);
 		return IRQ_NONE;
 	}
 
 	if (status & GSC_IRQ_STATUS_OR_FRM_DONE) {
-		dev_dbg(ippdrv->dev, "occured frame done at %d, status 0x%x.\n",
+		dev_dbg(ippdrv->dev, "frame done at %d, status 0x%x.\n",
 			ctx->id, status);
 
 		buf_id[EXYNOS_DRM_OPS_SRC] = gsc_get_src_buf_index(ctx);
-- 
1.8.2.451.gbfd70c5

