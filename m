Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3BFKz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:26 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:43648 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3BFKzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:12 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Zhenhua HUANG <zhenhua.huang@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 34/49] regulator: ab8500: Fix vsdio parameters for AB8540 based platforms
Date: Wed,  6 Feb 2013 10:53:56 +0000
Message-Id: <1360148051-7560-35-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhenhua HUANG <zhenhua.huang@stericsson.com>

Fix the parameters for vsdio in idle mode and normal mode.

Signed-off-by: Zhenhua HUANG <zhenhua.huang@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
Reviewed-by: Xiao Mei ZHANG <xiaomei.zhang@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
---
 drivers/regulator/ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index a8b0a3f..e463668 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1395,8 +1395,8 @@ static struct ab8500_regulator_info
 		.update_reg		= 0x88,
 		.update_mask		= 0x30,
 		.update_val		= 0x10,
-		.update_val_idle	= 0x00,
-		.update_val_normal	= 0x20,
+		.update_val_idle	= 0x30,
+		.update_val_normal	= 0x10,
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x88,
 		.voltage_mask		= 0x07,
-- 
1.7.9.5

