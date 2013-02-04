Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3BDMDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:03:53 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44521 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3BDL5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:22 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Zhenhua HUANG <zhenhua.huang@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 49/73] regulator: ab8500: Fix vsdio parameters for AB8540 based platforms
Date: Mon,  4 Feb 2013 11:54:04 +0000
Message-Id: <1359978868-28736-50-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
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
index 5218502..b09b507 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1412,8 +1412,8 @@ static struct ab8500_regulator_info
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

