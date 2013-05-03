Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab3ECOsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:48:19 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38133 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3ECOds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:48 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/63] ARM: ux500: Remove unused 'data_width' attributes from SDI DMA configs
Date: Fri,  3 May 2013 15:31:59 +0100
Message-Id: <1367591569-32197-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA configuration data is now allocated in the MMCI driver, so these
are just ignored.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-sdi.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 5c28216..553ace6 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -65,16 +65,12 @@ struct stedma40_chan_cfg mop500_sdi0_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_PERIPH_TO_MEM,
 	.dev_type = DB8500_DMA_DEV29_SD_MM0,
-	.src_info.data_width = STEDMA40_WORD_WIDTH,
-	.dst_info.data_width = STEDMA40_WORD_WIDTH,
 };
 
 static struct stedma40_chan_cfg mop500_sdi0_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_MEM_TO_PERIPH,
 	.dev_type = DB8500_DMA_DEV29_SD_MM0,
-	.src_info.data_width = STEDMA40_WORD_WIDTH,
-	.dst_info.data_width = STEDMA40_WORD_WIDTH,
 };
 #endif
 
@@ -134,16 +130,12 @@ static struct stedma40_chan_cfg sdi1_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_PERIPH_TO_MEM,
 	.dev_type = DB8500_DMA_DEV32_SD_MM1,
-	.src_info.data_width = STEDMA40_WORD_WIDTH,
-	.dst_info.data_width = STEDMA40_WORD_WIDTH,
 };
 
 static struct stedma40_chan_cfg sdi1_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_MEM_TO_PERIPH,
 	.dev_type = DB8500_DMA_DEV32_SD_MM1,
-	.src_info.data_width = STEDMA40_WORD_WIDTH,
-	.dst_info.data_width = STEDMA40_WORD_WIDTH,
 };
 #endif
 
@@ -169,16 +161,12 @@ struct stedma40_chan_cfg mop500_sdi2_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_PERIPH_TO_MEM,
 	.dev_type =  DB8500_DMA_DEV28_SD_MM2,
-	.src_info.data_width = STEDMA40_WORD_WIDTH,
-	.dst_info.data_width = STEDMA40_WORD_WIDTH,
 };
 
 static struct stedma40_chan_cfg mop500_sdi2_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_MEM_TO_PERIPH,
 	.dev_type = DB8500_DMA_DEV28_SD_MM2,
-	.src_info.data_width = STEDMA40_WORD_WIDTH,
-	.dst_info.data_width = STEDMA40_WORD_WIDTH,
 };
 #endif
 
@@ -205,16 +193,12 @@ struct stedma40_chan_cfg mop500_sdi4_dma_cfg_rx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_PERIPH_TO_MEM,
 	.dev_type =  DB8500_DMA_DEV42_SD_MM4,
-	.src_info.data_width = STEDMA40_WORD_WIDTH,
-	.dst_info.data_width = STEDMA40_WORD_WIDTH,
 };
 
 static struct stedma40_chan_cfg mop500_sdi4_dma_cfg_tx = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = STEDMA40_MEM_TO_PERIPH,
 	.dev_type = DB8500_DMA_DEV42_SD_MM4,
-	.src_info.data_width = STEDMA40_WORD_WIDTH,
-	.dst_info.data_width = STEDMA40_WORD_WIDTH,
 };
 #endif
 
-- 
1.7.10.4

