Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaJIS3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 14:29:53 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:58400 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJIS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:29:44 -0400
From: Rene Kolarik <rene.kolarik@gmail.com>
To: gregkh@linuxfoundation.org, shawn.guo@freescale.com, kernel@pengutronix.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Rene Kolarik <rene.kolarik@gmail.com>
Subject: [PATCH] drivers: staging: imx-drm driver cleanup
Date: Thu,  9 Oct 2014 20:29:32 +0200
Message-Id: <1412879372-2161-1-git-send-email-rene.kolarik@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrapping two too long lines in two files of the imx-drm driver.

Signed-off-by: Rene Kolarik <rene.kolarik@gmail.com>
---
 drivers/staging/imx-drm/imx-drm-core.c | 3 ++-
 drivers/staging/imx-drm/imx-tve.c      | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 9cb222e..3ca1acd 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -632,7 +632,8 @@ static int imx_drm_platform_probe(struct platform_device *pdev)
 				continue;
 			}
 
-			component_match_add(&pdev->dev, &match, compare_of, remote);
+			component_match_add(&pdev->dev, &match, compare_of,
+					    remote);
 			of_node_put(remote);
 		}
 		of_node_put(port);
diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index 42c651b..f22b2ac 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -665,7 +665,8 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 
 	ret = regmap_read(tve->regmap, TVE_COM_CONF_REG, &val);
 	if (ret < 0) {
-		dev_err(dev, "failed to read configuration register: %d\n", ret);
+		dev_err(dev, "failed to read configuration register: %d\n",
+			ret);
 		return ret;
 	}
 	if (val != 0x00100000) {
-- 
1.9.3

