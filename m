Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaBEREm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:04:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36357 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaBEREk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:04:40 -0500
From: Mark Brown <broonie@kernel.org>
To: Manish Vishwanathrao Badarkhe <manishv.b@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Wed,  5 Feb 2014 17:04:29 +0000
Message-Id: <1391619869-10347-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.9.rc1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: tps6507x: Fix !OF build
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/tps6507x-regulator.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 97868b781b29..862cc81f822f 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -359,7 +359,6 @@ static struct regulator_ops tps6507x_pmic_ops = {
 	.map_voltage = regulator_map_voltage_ascend,
 };
 
-#ifdef CONFIG_OF
 static struct of_regulator_match tps6507x_matches[] = {
 	{ .name = "VDCDC1"},
 	{ .name = "VDCDC2"},
@@ -367,7 +366,6 @@ static struct of_regulator_match tps6507x_matches[] = {
 	{ .name = "LDO1"},
 	{ .name = "LDO2"},
 };
-#endif
 
 static struct tps6507x_board *tps6507x_parse_dt_reg_data(
 		struct platform_device *pdev,
-- 
1.9.rc1

