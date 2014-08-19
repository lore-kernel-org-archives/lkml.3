Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaHSOAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:00:15 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:53474 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHSOAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:00:12 -0400
From: Yannis Damigos <giannis.damigos@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Yannis Damigos <giannis.damigos@gmail.com>
Subject: [PATCH 1/1] staging: imx-drm: Lines over 80 characters fixed.
Date: Tue, 19 Aug 2014 16:59:57 +0300
Message-Id: <1408456797-19437-1-git-send-email-giannis.damigos@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140819124112.GB7791@kroah.com>
References: <20140819124112.GB7791@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ipuv3-crtc.c file that fixes up two "lines
over 80 characters" warnings found by the checkpatch.pl tool.

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

