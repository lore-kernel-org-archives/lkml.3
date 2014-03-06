Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaCFM0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 07:26:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaCFM0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 07:26:48 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm: fix bochs kconfig dependencies
Date: Thu,  6 Mar 2014 13:26:36 +0100
Message-Id: <1394108796-7905-1-git-send-email-kraxel@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/bochs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bochs/Kconfig b/drivers/gpu/drm/bochs/Kconfig
index c8fcf12..5f8b0c2 100644
--- a/drivers/gpu/drm/bochs/Kconfig
+++ b/drivers/gpu/drm/bochs/Kconfig
@@ -2,6 +2,7 @@ config DRM_BOCHS
 	tristate "DRM Support for bochs dispi vga interface (qemu stdvga)"
 	depends on DRM && PCI
 	select DRM_KMS_HELPER
+	select DRM_KMS_FB_HELPER
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
-- 
1.8.3.1

