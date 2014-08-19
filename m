Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaHSL6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:58:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39325 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaHSL6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:58:17 -0400
From: Yannis Damigos <giannis.damigos@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Yannis Damigos <giannis.damigos@gmail.com>
Subject: [PATCH 1/1] Fix some code style issues
Date: Tue, 19 Aug 2014 14:57:11 +0300
Message-Id: <1408449431-28224-1-git-send-email-giannis.damigos@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yannis Damigos <giannis.damigos@gmail.com>
---
 drivers/staging/imx-drm/ipuv3-crtc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 720868b..c4c6455 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -201,9 +201,9 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 		return ret;
 	}
 
-	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode, crtc->primary->fb,
-				  0, 0, mode->hdisplay, mode->vdisplay,
-				  x, y, mode->hdisplay, mode->vdisplay);
+	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode,
+			crtc->primary->fb, 0, 0, mode->hdisplay, mode->vdisplay,
+			x, y, mode->hdisplay, mode->vdisplay);
 }
 
 static void ipu_crtc_handle_pageflip(struct ipu_crtc *ipu_crtc)
@@ -227,7 +227,8 @@ static irqreturn_t ipu_irq_handler(int irq, void *dev_id)
 
 	if (ipu_crtc->newfb) {
 		ipu_crtc->newfb = NULL;
-		ipu_plane_set_base(ipu_crtc->plane[0], ipu_crtc->base.primary->fb,
+		ipu_plane_set_base(ipu_crtc->plane[0],
+				ipu_crtc->base.primary->fb,
 				ipu_crtc->plane[0]->x, ipu_crtc->plane[0]->y);
 		ipu_crtc_handle_pageflip(ipu_crtc);
 	}
-- 
2.0.4

