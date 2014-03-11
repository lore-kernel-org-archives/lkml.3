Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaCKKYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:24:04 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:52188 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbaCKKX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH trivial 03/16] drm/exynos: Spelling s/contro/control/
Date: Tue, 11 Mar 2014 11:23:37 +0100
Message-Id: <1394533430-4746-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 09312b877470..3d78144387ac 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -284,7 +284,7 @@ static struct exynos_drm_ippdrv *ipp_find_drv_by_handle(u32 prop_id)
 	/*
 	 * This case is search ipp driver by prop_id handle.
 	 * sometimes, ipp subsystem find driver by prop_id.
-	 * e.g PAUSE state, queue buf, command contro.
+	 * e.g PAUSE state, queue buf, command control.
 	 */
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
 		DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]\n", count++, (int)ippdrv);
-- 
1.7.9.5

