Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaGBMXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:23:13 -0400
Received: from gnurou.org ([207.192.72.5]:55657 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbaGBMWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:22:30 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/4] drm/panel: LG LH500WX1-SD03 uses continuous clock
Date: Wed,  2 Jul 2014 21:19:19 +0900
Message-Id: <1404303560-32209-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This panel can only operate in continuous clock behavior, so set the
appropriate flag to inform host drivers of this fact.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index a251361..428cdf3 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -572,7 +572,7 @@ static const struct panel_desc_dsi lg_lh500wx1_sd03 = {
 			.height = 110,
 		},
 	},
-	.flags = MIPI_DSI_MODE_VIDEO,
+	.flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_CLOCK_CONTINUOUS,
 	.format = MIPI_DSI_FMT_RGB888,
 	.lanes = 4,
 };
-- 
2.0.0

