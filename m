Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaCCTKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:10:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45086 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaCCTKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:10:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: <airlied@linux.ie>
CC: <airlied@redhat.com>, <robdclark@gmail.com>, <bparrot@ti.com>,
        <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>
Subject: [PATCH] drm/tilcdc increase allowable supported resolution
Date: Mon, 3 Mar 2014 13:08:58 -0600
Message-ID: <1393873738-27327-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Etheridge <detheridge@ti.com>

1680x1050 appears to also be within the bandwidth capabilities
of the device and memory infrastructure.

Signed-off-by: Darren Etheridge <detheridge@ti.com>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.h b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
index 5bb64e3..b47ec24 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.h
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
@@ -43,7 +43,7 @@
  * with optimized DDR & EMIF settings tweaked 1920x1080@24 appears to
  * be supportable
  */
-#define TILCDC_DEFAULT_MAX_BANDWIDTH  (1280*1024*60)
+#define TILCDC_DEFAULT_MAX_BANDWIDTH  (1680*1050*60)
 
 
 struct tilcdc_drm_private {
-- 
1.9.0

