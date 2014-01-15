Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaAOK1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:27:30 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:55222 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaAOK12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:27:28 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] at91: dt: i2c: add a new compatibility string for the at91sam9261
Date: Wed, 15 Jan 2014 11:24:27 +0100
Message-Id: <1389781467-29626-1-git-send-email-jjhiblot@traphandler.com>
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

