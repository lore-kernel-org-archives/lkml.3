Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaHSOhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:37:20 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52736 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaHSOhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:37:18 -0400
From: Yannis Damigos <giannis.damigos@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Yannis Damigos <giannis.damigos@gmail.com>
Subject: [PATCH 1/1] staging: imx-drm: Lines over 80 characters fixed.
Date: Tue, 19 Aug 2014 17:36:10 +0300
Message-Id: <1408458970-27097-2-git-send-email-giannis.damigos@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408458970-27097-1-git-send-email-giannis.damigos@gmail.com>
References: <1408457139.2899.11.camel@paszta.hi.pengutronix.de>
 <1408458970-27097-1-git-send-email-giannis.damigos@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ipuv3-crtc.c file that fixes up two "lines
over 80 characters" warnings found by the checkpatch.pl tool,
keeping the alignment of the x/y/width/height parameters for
readability.

Signed-off-by: Yannis Damigos <giannis.damigos@gmail.com>
---
 drivers/staging/imx-drm/ipuv3-crtc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 720868b..d6657a0 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -201,9 +201,10 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 		return ret;
 	}
 
-	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode, crtc->primary->fb,
-				  0, 0, mode->hdisplay, mode->vdisplay,
-				  x, y, mode->hdisplay, mode->vdisplay);
+	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode,
+			crtc->primary->fb,
+			0, 0, mode->hdisplay, mode->vdisplay,
+			x, y, mode->hdisplay, mode->vdisplay);
 }
 
 static void ipu_crtc_handle_pageflip(struct ipu_crtc *ipu_crtc)
@@ -227,7 +228,8 @@ static irqreturn_t ipu_irq_handler(int irq, void *dev_id)
 
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

