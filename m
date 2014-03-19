Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941AbaCSMjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:39:24 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42613 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865AbaCSMjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:39:22 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] regulator: max8660: Fix brace alignment
Date: Wed, 19 Mar 2014 18:02:58 +0530
Message-Id: <1395232378-26320-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the "};" to next line as is the general coding practice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8660.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index aabfb3b2407c..2fc411188794 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -86,7 +86,8 @@ struct max8660 {
 static int max8660_write(struct max8660 *max8660, u8 reg, u8 mask, u8 val)
 {
 	static const u8 max8660_addresses[MAX8660_N_REGS] = {
-	  0x10, 0x12, 0x20, 0x23, 0x24, 0x29, 0x2a, 0x32, 0x33, 0x39, 0x80 };
+	 0x10, 0x12, 0x20, 0x23, 0x24, 0x29, 0x2a, 0x32, 0x33, 0x39, 0x80
+	};
 
 	int ret;
 	u8 reg_val = (max8660->shadow_regs[reg] & mask) | val;
-- 
1.7.9.5

