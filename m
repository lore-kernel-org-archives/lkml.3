Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab3KUOaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:30:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57792 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab3KUOaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:30:06 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH] i915, fbdev: Fix Kconfig typo
Date: Thu, 21 Nov 2013 15:29:55 +0100
Message-Id: <1385044195-13318-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Too many t's.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/gpu/drm/i915/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index 6199d0b5b958..7ca35ecfd952 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -43,7 +43,7 @@ config DRM_I915_KMS
 	  like intelfb.
 
 config DRM_I915_FBDEV
-	bool "Enable legacy fbdev support for the modesettting intel driver"
+	bool "Enable legacy fbdev support for the modesetting intel driver"
 	depends on DRM_I915
 	select DRM_KMS_FB_HELPER
 	select FB_CFB_FILLRECT
-- 
1.8.4

