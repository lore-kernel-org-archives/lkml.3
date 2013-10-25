Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3JYUK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 16:10:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33405 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3JYUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 16:10:27 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Fri, 25 Oct 2013 21:10:00 +0100
Message-Id: <1382731800-19663-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: as3722: Don't export the regmap config
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

It's not used outside this file so can be static.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/as3722.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/as3722.c b/drivers/mfd/as3722.c
index cd8ee59..f161f2e 100644
--- a/drivers/mfd/as3722.c
+++ b/drivers/mfd/as3722.c
@@ -314,7 +314,7 @@ static const struct regmap_access_table as3722_volatile_table = {
 	.n_no_ranges = ARRAY_SIZE(as3722_cacheable_ranges),
 };
 
-const struct regmap_config as3722_regmap_config = {
+static const struct regmap_config as3722_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = AS3722_MAX_REGISTER,
-- 
1.8.4.rc3

