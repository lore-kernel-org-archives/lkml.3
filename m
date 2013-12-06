Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab3LFXXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:23:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423043Ab3LFXUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 056/152] drm: shmobile: Add dependency on BACKLIGHT_CLASS_DEVICE
Date: Fri,  6 Dec 2013 15:09:40 -0800
Message-Id: <1386371476-2477-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 0a5a5499ad886dde4a032203d01e324cfe593f99 upstream.

The driver registers a backlight device and thus requires
BACKLIGHT_CLASS_DEVICE to be selected to avoid compilation breakages.

Reported-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/shmobile/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/shmobile/Kconfig b/drivers/gpu/drm/shmobile/Kconfig
index 7e7d52b..cb4beb5 100644
--- a/drivers/gpu/drm/shmobile/Kconfig
+++ b/drivers/gpu/drm/shmobile/Kconfig
@@ -1,6 +1,7 @@
 config DRM_SHMOBILE
 	tristate "DRM Support for SH Mobile"
 	depends on DRM && (SUPERH || ARCH_SHMOBILE)
+	select BACKLIGHT_CLASS_DEVICE
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
-- 
1.8.3.2

