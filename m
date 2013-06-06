Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3FFLV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:21:27 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58105 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab3FFLVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:21:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/4] mfd: dbx500-prcmu: Use correct names for clock management registers
Date: Thu,  6 Jun 2013 12:21:13 +0100
Message-Id: <1370517676-10909-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
References: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... as stipulated by the Hardware Specification document.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/dbx500-prcmu-regs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
index d14836e..7cc32a8 100644
--- a/drivers/mfd/dbx500-prcmu-regs.h
+++ b/drivers/mfd/dbx500-prcmu-regs.h
@@ -16,8 +16,8 @@
 #define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
 
 #define PRCM_ACLK_MGT		(0x004)
-#define PRCM_SVACLK_MGT		(0x008)
-#define PRCM_SIACLK_MGT		(0x00C)
+#define PRCM_SVAMMCSPCLK_MGT	(0x008)
+#define PRCM_SIAMMDSPCLK_MGT	(0x00C)
 #define PRCM_SGACLK_MGT		(0x014)
 #define PRCM_UARTCLK_MGT	(0x018)
 #define PRCM_MSP02CLK_MGT	(0x01C)
-- 
1.7.10.4

