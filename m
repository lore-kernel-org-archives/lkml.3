Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaBSQh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:37:29 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:47581 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbaBSQhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:37:25 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-14.tower-194.messagelabs.com!1392827842!11157569!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402191637.s1JGb4t9017699@swsrvapps-02.lan>
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Date: Wed, 19 Feb 2014 16:32:47 +0000
Subject: [PATCH V1 3/3] REGULATOR: da9052: Add new DA9053 BC chip variant
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for a new BC variant of the DA9053 PMIC.

There is one difference between it and the AA, BA and BB.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140219

This patch depends on patch number 1 of this patch
series being applied first or it will not compile.

 drivers/regulator/da9052-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 889c7c9..599f2ad 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -354,6 +354,7 @@ static inline struct da9052_regulator_info *find_regulator_info(u8 chip_id,
 	case DA9053_AA:
 	case DA9053_BA:
 	case DA9053_BB:
+	case DA9053_BC:
 		for (i = 0; i < ARRAY_SIZE(da9053_regulator_info); i++) {
 			info = &da9053_regulator_info[i];
 			if (info->reg_desc.id == id)
-- 
end-of-patch 3/3 for PATCH V1

