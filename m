Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3BDL6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:58:03 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61805 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab3BDL6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:58:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: David Paris <david.paris@stericsson.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 65/73] regulator: ab8500: Update VAna supply management for the AB9540
Date: Mon,  4 Feb 2013 11:54:20 +0000
Message-Id: <1359978868-28736-66-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Paris <david.paris@stericsson.com>

Workaround to switch off VAna when going to suspend. In combination
with workaround that makes VAna always ON in running mode.

Signed-off-by: David Paris <david.paris@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Yvon CORRE <yvon.corre@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/regulator/ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index f31669e..fa0979a 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1451,9 +1451,9 @@ static struct ab8500_regulator_info
 		.update_bank		= 0x04,
 		.update_reg		= 0x06,
 		.update_mask		= 0x0c,
-		.update_val		= 0x04,
+		.update_val		= 0x08,
 		.update_val_idle	= 0x0c,
-		.update_val_normal	= 0x04,
+		.update_val_normal	= 0x08,
 	},
 };
 
-- 
1.7.9.5

