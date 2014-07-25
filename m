Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725AbaGYRbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:31:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54937 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839AbaGYRbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:31:33 -0400
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Fri, 25 Jul 2014 18:31:22 +0100
Message-Id: <1406309483-29590-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: Allow regmap_get_device() to be used by modules
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 5ba0263fce21..78f43fb2fe84 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1084,6 +1084,7 @@ struct device *regmap_get_device(struct regmap *map)
 {
 	return map->dev;
 }
+EXPORT_SYMBOL_GPL(regmap_get_device);
 
 static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 			       struct regmap_range_node *range,
-- 
2.0.1

