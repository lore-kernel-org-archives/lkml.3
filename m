Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3F1Q4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:56:06 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:38745 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab3F1Qz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:55:58 -0400
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 3/4] imx-drm: ipu-dp: Remove unneeded braces
Date: Fri, 28 Jun 2013 13:55:29 -0300
Message-Id: <1372438530-1819-3-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372438530-1819-1-git-send-email-festevam@gmail.com>
References: <1372438530-1819-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

No need to have braces for a single line 'if' block

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- None

 drivers/staging/imx-drm/ipu-v3/ipu-dp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
index 0449515..6e0e9f1 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
@@ -317,9 +317,8 @@ int ipu_dp_init(struct ipu_soc *ipu, struct device *dev, unsigned long base)
 	ipu->dp_priv = priv;
 
 	priv->base = devm_ioremap(dev, base, PAGE_SIZE);
-	if (!priv->base) {
+	if (!priv->base)
 		return -ENOMEM;
-	}
 
 	mutex_init(&priv->mutex);
 
-- 
1.8.1.2

