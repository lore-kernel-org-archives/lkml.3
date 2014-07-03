Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbaGCPSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:18:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52135 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755329AbaGCPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:18:16 -0400
From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Nikesh Oswal <Nikesh.Oswal@wolfsonmicro.com>
Subject: [PATCH] regulator: arizona-ldo1: remove bypass functionality
Date: Thu,  3 Jul 2014 16:18:07 +0100
Message-Id: <1404400687-19035-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikesh Oswal <Nikesh.Oswal@wolfsonmicro.com>

WM5110/8280 devices do not support bypass mode for LDO1 so remove
the bypass callbacks registered with regulator core.

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 04f262a..4c9db58 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -143,8 +143,6 @@ static struct regulator_ops arizona_ldo1_ops = {
 	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
-	.get_bypass = regulator_get_bypass_regmap,
-	.set_bypass = regulator_set_bypass_regmap,
 };
 
 static const struct regulator_desc arizona_ldo1 = {
-- 
1.7.9.5

