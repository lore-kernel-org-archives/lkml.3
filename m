Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaAONUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:20:25 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49503 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaAONUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:20:21 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, wsa@the-dreams.de
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH repost] at91: dt: i2c: add a new compatibility string for the at91sam9261
Date: Wed, 15 Jan 2014 14:17:13 +0100
Message-Id: <1389791833-7572-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/i2c/busses/i2c-at91.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 8edba9d..843d012 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -589,6 +589,9 @@ static const struct of_device_id atmel_twi_dt_ids[] = {
 		.compatible = "atmel,at91sam9260-i2c",
 		.data = &at91sam9260_config,
 	} , {
+		.compatible = "atmel,at91sam9261-i2c",
+		.data = &at91sam9261_config,
+	} , {
 		.compatible = "atmel,at91sam9g20-i2c",
 		.data = &at91sam9g20_config,
 	} , {
-- 
1.8.5.2

