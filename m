Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139Ab3CUQCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:02:30 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59177 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934063Ab3CUQBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:01:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 44/46] regulator: ab8500: Amend the update value for AB8500_LDO_INTCORE regulator
Date: Thu, 21 Mar 2013 15:59:41 +0000
Message-Id: <1363881583-15234-45-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issues probably originated from a typo in the initial submission.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index e82b0ad..72d1ed7 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -802,7 +802,7 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x03,
 		.update_reg		= 0x80,
 		.update_mask		= 0x44,
-		.update_val		= 0x04,
+		.update_val		= 0x44,
 		.update_val_idle	= 0x44,
 		.update_val_normal	= 0x04,
 		.voltage_bank		= 0x03,
-- 
1.7.10.4

