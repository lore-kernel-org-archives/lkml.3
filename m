Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbaIOWOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:14:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbaIOWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:14:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 060/187] regulator: arizona-ldo1: remove bypass functionality
Date: Mon, 15 Sep 2014 15:07:50 -0700
Message-Id: <1410818997-9432-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>

commit 5b919f3ebb533cbe400664837e24f66a0836b907 upstream.

WM5110/8280 devices do not support bypass mode for LDO1 so remove
the bypass callbacks registered with regulator core.

Signed-off-by: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/regulator/arizona-ldo1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index f0ea4fd..8b963a7 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -141,8 +141,6 @@ static struct regulator_ops arizona_ldo1_ops = {
 	.map_voltage = regulator_map_voltage_linear,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
-	.get_bypass = regulator_get_bypass_regmap,
-	.set_bypass = regulator_set_bypass_regmap,
 };
 
 static const struct regulator_desc arizona_ldo1 = {
-- 
1.9.1

