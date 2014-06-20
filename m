Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbaFTJSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:18:04 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37398 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaFTJSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:18:02 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, spk.linux@gmail.com
Subject: [PATCH Resend 1/1] regulator: ltc3589: Staticize ltc3589_reg_defaults
Date: Fri, 20 Jun 2014 14:44:52 +0530
Message-Id: <1403255692-31102-1-git-send-email-sachin.kamat@samsung.com>
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
index c8105182b8b8..c756955bfcc5 100644
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

