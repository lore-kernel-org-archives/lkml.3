Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3BRFOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:14:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36732 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab3BRFOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:14:15 -0500
From: J Keerthy <j-keerthy@ti.com>
To: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
CC: <j-keerthy@ti.com>, <gg@slimlogic.co.uk>
Subject: [PATCH 2/4] mfd: palmas: Change the DT node property names to follow the convention
Date: Mon, 18 Feb 2013 10:42:44 +0530
Message-ID: <1361164364-3175-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT node properties should not have "_". Replacing them by "-".

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 drivers/mfd/palmas.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 6ffd7a2..d8467cf 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -253,20 +253,20 @@ static void palmas_dt_to_pdata(struct device_node *node,
 	int ret;
 	u32 prop;
 
-	ret = of_property_read_u32(node, "ti,mux_pad1", &prop);
+	ret = of_property_read_u32(node, "ti,mux-pad1", &prop);
 	if (!ret) {
 		pdata->mux_from_pdata = 1;
 		pdata->pad1 = prop;
 	}
 
-	ret = of_property_read_u32(node, "ti,mux_pad2", &prop);
+	ret = of_property_read_u32(node, "ti,mux-pad2", &prop);
 	if (!ret) {
 		pdata->mux_from_pdata = 1;
 		pdata->pad2 = prop;
 	}
 
 	/* The default for this register is all masked */
-	ret = of_property_read_u32(node, "ti,power_ctrl", &prop);
+	ret = of_property_read_u32(node, "ti,power-ctrl", &prop);
 	if (!ret)
 		pdata->power_ctrl = prop;
 	else
-- 
1.7.5.4

