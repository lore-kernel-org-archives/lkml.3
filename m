Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaAXMvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:51:32 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:47304 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaAXMuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:50:11 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 14/15] ARM: shmobile: koelsch legacy: Enable Quad SPI transfers for the SPI FLASH
Date: Fri, 24 Jan 2014 13:49:50 +0100
Message-Id: <1390567791-8988-15-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
References: <1390567791-8988-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
This depends on spi-rspi and m25p80 updates

 arch/arm/mach-shmobile/board-koelsch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/board-koelsch.c b/arch/arm/mach-shmobile/board-koelsch.c
index 56020d9fa841..4cb8674bc4a8 100644
--- a/arch/arm/mach-shmobile/board-koelsch.c
+++ b/arch/arm/mach-shmobile/board-koelsch.c
@@ -195,7 +195,7 @@ static const struct spi_board_info spi_info[] __initconst = {
 	{
 		.modalias	= "m25p80",
 		.platform_data	= &spi_flash_data,
-		.mode		= SPI_MODE_0,
+		.mode		= SPI_MODE_0 | SPI_TX_QUAD | SPI_RX_QUAD,
 		.max_speed_hz	= 30000000,
 		.bus_num	= 0,
 		.chip_select	= 0,
-- 
1.7.9.5

