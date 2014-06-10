Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaFJGho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 02:37:44 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42324 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaFJGhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 02:37:43 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, spk.linux@gmail.com,
        p.zabel@pengutronix.de
Subject: [PATCH 1/1] regulator: ltc3589: Staticize ltc3589_reg_defaults
Date: Tue, 10 Jun 2014 12:04:53 +0530
Message-Id: <1402382093-27338-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'ltc3589_reg_defaults' is local to this file. Make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/regulator/ltc3589.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ltc3589.c b/drivers/regulator/ltc3589.c
index 110a99e..217d10d6 100644
--- a/drivers/regulator/ltc3589.c
+++ b/drivers/regulator/ltc3589.c
@@ -377,7 +377,7 @@ static bool ltc3589_volatile_reg(struct device *dev, unsigned int reg)
 	return false;
 }
 
-struct reg_default ltc3589_reg_defaults[] = {
+static struct reg_default ltc3589_reg_defaults[] = {
 	{ LTC3589_SCR1,   0x00 },
 	{ LTC3589_OVEN,   0x00 },
 	{ LTC3589_SCR2,   0x00 },
-- 
1.7.9.5

