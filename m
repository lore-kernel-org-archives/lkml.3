Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3FZE6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:58:45 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60610 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3FZE6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:58:44 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 1/1] regulator: ab8500-ext: Staticize local symbols
Date: Wed, 26 Jun 2013 10:13:37 +0530
Message-Id: <1372221817-4382-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local symbols used only in this file are made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
---
 drivers/regulator/ab8500-ext.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 4137a2f..02ff691 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -341,7 +341,7 @@ static struct of_regulator_match ab8500_ext_regulator_match[] = {
 	{ .name = "ab8500_ext3", .driver_data = (void *) AB8500_EXT_SUPPLY3, },
 };
 
-int ab8500_ext_regulator_probe(struct platform_device *pdev)
+static int ab8500_ext_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *ppdata;
@@ -433,7 +433,7 @@ int ab8500_ext_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-int ab8500_ext_regulator_remove(struct platform_device *pdev)
+static int ab8500_ext_regulator_remove(struct platform_device *pdev)
 {
 	int i;
 
-- 
1.7.9.5

