Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaBINBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:01:37 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:54673 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbaBINBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:01:35 -0500
Message-ID: <1391950893.20670.2.camel@x220>
Subject: [PATCH] drm/tegra: fix typo 'CONFIG_TEGRA_DRM_FBDEV'
From: Paul Bolle <pebolle@tiscali.nl>
To: Thierry Reding <thierry.reding@gmail.com>,
        Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 14:01:33 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 13:01:34.0073 (UTC) FILETIME=[0F1AAE90:01CF2597]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested. But it's clear that this is what was intended.

 drivers/gpu/drm/tegra/drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 88a5290..c715947 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -104,7 +104,7 @@ static void tegra_drm_context_free(struct tegra_drm_context *context)
 
 static void tegra_drm_lastclose(struct drm_device *drm)
 {
-#ifdef CONFIG_TEGRA_DRM_FBDEV
+#ifdef CONFIG_DRM_TEGRA_FBDEV
 	struct tegra_drm *tegra = drm->dev_private;
 
 	tegra_fbdev_restore_mode(tegra->fbdev);
-- 
1.8.5.3

