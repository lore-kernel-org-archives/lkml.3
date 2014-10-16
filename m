Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaJPCjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 22:39:14 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:52201 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaJPCjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 22:39:13 -0400
From: Gaston Gonzalez <gascoar@gmail.com>
To: gregkh@linuxfoundation.org, grant.likely@linaro.org, robh+dt@kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Gaston Gonzalez <gascoar@gmail.com>
Subject: [PATCH] drivers: staging: imx-drm Fix checkpatch warning
Date: Wed, 15 Oct 2014 23:37:24 -0300
Message-Id: <1413427044-9980-1-git-send-email-gascoar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix line over 80 characters in imx-tve.c

Signed-off-by: Gaston Gonzalez <gascoar@gmail.com>
---
 drivers/staging/imx-drm/imx-tve.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index 3e8b0a1..a46905f 100644
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
1.7.10.4

