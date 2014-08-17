Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbaHQE0F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 00:26:05 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:41525 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaHQE0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 00:26:03 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/3] staging: comedi: addi_apci_1564: correct typo in macro definition
Date: Sat, 16 Aug 2014 23:25:51 -0500
Message-Id: <1408249551-903-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent commit introduced a typo in the definition of
APCI1564_DO_CC_INT_DISABLE.  The macro is not use yet, so not a huge deal,
but this patch corrects it.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 198c627..59f092d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -33,7 +33,7 @@
 #define APCI1564_DO_VCC_INT_ENABLE			0x1
 #define APCI1564_DO_VCC_INT_DISABLE			0xfffffffe
 #define APCI1564_DO_CC_INT_ENABLE			0x2
-#define APCI1564_DO_CC_IN_DISABLE			0xfffffffd
+#define APCI1564_DO_CC_INT_DISABLE			0xfffffffd
 
 /* TIMER COUNTER WATCHDOG DEFINES */
 #define ADDIDATA_TIMER					0
-- 
2.0.4

