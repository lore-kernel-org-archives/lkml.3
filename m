Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3F1Qzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:55:54 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:47526 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3F1Qzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:55:53 -0400
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 1/4] imx-drm: imx-drm-core: Export imx_drm_encoder_get_mux_id
Date: Fri, 28 Jun 2013 13:55:27 -0300
Message-Id: <1372438530-1819-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

When building imx_v6_v7_defconfig with imx-drm drivers selected as modules, we
get the following build error:

ERROR: "imx_drm_encoder_get_mux_id" [drivers/staging/imx-drm/imx-ldb.ko] undefined!

Export the required function to avoid this problem.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- None

 drivers/staging/imx-drm/imx-drm-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 9854a1d..6bc205b 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -678,6 +678,7 @@ found:
 
 	return i;
 }
+EXPORT_SYMBOL_GPL(imx_drm_encoder_get_mux_id);
 
 /*
  * imx_drm_remove_encoder - remove an encoder
-- 
1.8.1.2

