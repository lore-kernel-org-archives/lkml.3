Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaGVLMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:12:07 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:62112 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaGVLMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:12:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/19] mfd: twl6030-irq: Extinguish coding style warnings
Date: Tue, 22 Jul 2014 12:11:20 +0100
Message-Id: <1406027485-15657-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part of an effort to clean-up the MFD subsystem.

WARNING: please, no space before tabs
+^IRSV_INTR_OFFSET,  ^I/* Bit 12^IReserved^I^I*/$

WARNING: Missing a blank line after declarations
+       u8 unmask_value;
+       ret = twl_i2c_read_u8(TWL_MODULE_PIH, &unmask_value,

WARNING: Missing a blank line after declarations
+       u8 mask_value;
+       ret = twl_i2c_read_u8(TWL_MODULE_PIH, &mask_value,

total: 0 errors, 3 warnings, 484 lines checked

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/twl6030-irq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index a6bb17d..2807e1a 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -70,7 +70,7 @@ static int twl6030_interrupt_mapping[24] = {
 	BATDETECT_INTR_OFFSET,	/* Bit 9	BAT			*/
 	SIMDETECT_INTR_OFFSET,	/* Bit 10	SIM			*/
 	MMCDETECT_INTR_OFFSET,	/* Bit 11	MMC			*/
-	RSV_INTR_OFFSET,  	/* Bit 12	Reserved		*/
+	RSV_INTR_OFFSET,	/* Bit 12	Reserved		*/
 	MADC_INTR_OFFSET,	/* Bit 13	GPADC_RT_EOC		*/
 	MADC_INTR_OFFSET,	/* Bit 14	GPADC_SW_EOC		*/
 	GASGAUGE_INTR_OFFSET,	/* Bit 15	CC_AUTOCAL		*/
@@ -245,6 +245,7 @@ int twl6030_interrupt_unmask(u8 bit_mask, u8 offset)
 {
 	int ret;
 	u8 unmask_value;
+
 	ret = twl_i2c_read_u8(TWL_MODULE_PIH, &unmask_value,
 			REG_INT_STS_A + offset);
 	unmask_value &= (~(bit_mask));
@@ -258,6 +259,7 @@ int twl6030_interrupt_mask(u8 bit_mask, u8 offset)
 {
 	int ret;
 	u8 mask_value;
+
 	ret = twl_i2c_read_u8(TWL_MODULE_PIH, &mask_value,
 			REG_INT_STS_A + offset);
 	mask_value |= (bit_mask);
-- 
1.8.3.2

