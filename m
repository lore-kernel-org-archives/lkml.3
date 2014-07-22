Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaGVLLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:11:54 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39233 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbaGVLLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:11:49 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/19] mfd: dm355evm_msp: Fix checkpatch error: insert space after ','
Date: Tue, 22 Jul 2014 12:11:12 +0100
Message-Id: <1406027485-15657-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

ERROR: space required after that ',' (ctx:VxV)
+#define MSP_GPIO(bit,reg)      ((DM355EVM_MSP_ ## reg) << 3 | (bit))
                     ^

total: 1 errors, 0 warnings, 437 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/dm355evm_msp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
index 7a55c00..4c826f7 100644
--- a/drivers/mfd/dm355evm_msp.c
+++ b/drivers/mfd/dm355evm_msp.c
@@ -95,7 +95,7 @@ EXPORT_SYMBOL(dm355evm_msp_read);
  * Many of the msp430 pins are just used as fixed-direction GPIOs.
  * We could export a few more of them this way, if we wanted.
  */
-#define MSP_GPIO(bit,reg)	((DM355EVM_MSP_ ## reg) << 3 | (bit))
+#define MSP_GPIO(bit, reg)	((DM355EVM_MSP_ ## reg) << 3 | (bit))
 
 static const u8 msp_gpios[] = {
 	/* eight leds */
-- 
1.8.3.2

