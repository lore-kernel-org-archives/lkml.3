Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbaEZJKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:10:13 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61796 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaEZJKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:10:11 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: pawel.moll@arm.com, broonie@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] bus: vexpress-config: Export devm_regmap_init_vexpress_config
Date: Mon, 26 May 2014 14:37:53 +0530
Message-Id: <1401095273-14492-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export this symbol to avoid build error when built as module.
ERROR: "devm_regmap_init_vexpress_config" [drivers/regulator/vexpress.ko] undefined!

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/bus/vexpress-config.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/vexpress-config.c b/drivers/bus/vexpress-config.c
index 27a07dfcd626..2af2227874af 100644
--- a/drivers/bus/vexpress-config.c
+++ b/drivers/bus/vexpress-config.c
@@ -118,6 +118,7 @@ struct regmap *devm_regmap_init_vexpress_config(struct device *dev)
 
 	return regmap;
 }
+EXPORT_SYMBOL(devm_regmap_init_vexpress_config);
 
 
 struct device *vexpress_config_bridge_register(struct device *parent,
-- 
1.7.9.5

