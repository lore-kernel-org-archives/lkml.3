Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab3E0N6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:58:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab3E0N6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:58:13 -0400
From: Andrew Jones <drjones@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: airlied@linux.ie, airlied@redhat.com, alevy@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] qxl: fix Kconfig deps - select FB_DEFERRED_IO
Date: Mon, 27 May 2013 15:58:04 +0200
Message-Id: <1369663084-7587-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 drivers/gpu/drm/qxl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/qxl/Kconfig b/drivers/gpu/drm/qxl/Kconfig
index 2f1a57e11140a..d6c12796023cd 100644
--- a/drivers/gpu/drm/qxl/Kconfig
+++ b/drivers/gpu/drm/qxl/Kconfig
@@ -4,6 +4,7 @@ config DRM_QXL
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
+	select FB_DEFERRED_IO
         select DRM_KMS_HELPER
         select DRM_TTM
 	help
-- 
1.8.1.4

