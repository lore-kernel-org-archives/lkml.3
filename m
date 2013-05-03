Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab3ECOrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:47:53 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39107 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373Ab3ECOdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 15/63] ARM: ux500: Remove unused 'data_width' attributes from UART DMA configs
Date: Fri,  3 May 2013 15:32:01 +0100
Message-Id: <1367591569-32197-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA configuration data is now allocated in the UART driver, so these
are just ignored.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 35fd82f..883dc66 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -530,48 +530,36 @@ static struct stedma40_chan_cfg uart0_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_PERIPH_TO_MEM,
 	.dev_type = DB8500_DMA_DEV13_UART0,
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 };
 
 static struct stedma40_chan_cfg uart0_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_MEM_TO_PERIPH,
 	.dev_type = DB8500_DMA_DEV13_UART0,
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 };
 
 static struct stedma40_chan_cfg uart1_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_PERIPH_TO_MEM,
 	.dev_type = DB8500_DMA_DEV12_UART1,
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 };
 
 static struct stedma40_chan_cfg uart1_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_MEM_TO_PERIPH,
 	.dev_type = DB8500_DMA_DEV12_UART1,
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 };
 
 static struct stedma40_chan_cfg uart2_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_PERIPH_TO_MEM,
 	.dev_type = DB8500_DMA_DEV11_UART2,
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 };
 
 static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_MEM_TO_PERIPH,
 	.dev_type = DB8500_DMA_DEV11_UART2,
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 };
 #endif
 
-- 
1.7.10.4

