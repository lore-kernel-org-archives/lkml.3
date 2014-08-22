Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaHVMEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:04:49 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:48072 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaHVMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:04:48 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 1/2] drivers/gpu/drm/exynos/exynos_drm_fb.h: Fix typo in include guard
Date: Fri, 22 Aug 2014 14:04:35 +0200
Message-Id: <1408709076-13260-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/gpu/drm/exynos/exynos_drm_fb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fb.h b/drivers/gpu/drm/exynos/exynos_drm_fb.h
index 517471b..09ce2bc 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fb.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_fb.h
@@ -12,7 +12,7 @@
  */
 
 #ifndef _EXYNOS_DRM_FB_H_
-#define _EXYNOS_DRM_FB_H
+#define _EXYNOS_DRM_FB_H_
 
 struct drm_framebuffer *
 exynos_drm_framebuffer_init(struct drm_device *dev,
-- 
1.9.2

