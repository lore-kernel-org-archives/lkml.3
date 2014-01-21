Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaAUPLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:11:20 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:52075 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbaAUPKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:10:21 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 5/5] spi: rspi: Document support for Renesas QSPI in Kconfig
Date: Tue, 21 Jan 2014 16:10:09 +0100
Message-Id: <1390317009-8292-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

As of commit 5ce0ba88650f2606244a761d92e2b725f4ab3583 ("spi: rcar: add
Renesas QSPI support on RSPI") the rspi driver handles Renesas QSPI, too,
but this was not reflected in the Kconfig help text.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 5072b71baf5e..3aafc2cd5db0 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -376,10 +376,10 @@ config SPI_PXA2XX_PCI
 	def_tristate SPI_PXA2XX && PCI
 
 config SPI_RSPI
-	tristate "Renesas RSPI controller"
+	tristate "Renesas RSPI/QSPI controller"
 	depends on (SUPERH && SH_DMAE_BASE) || ARCH_SHMOBILE
 	help
-	  SPI driver for Renesas RSPI blocks.
+	  SPI driver for Renesas RSPI and QSPI blocks.
 
 config SPI_S3C24XX
 	tristate "Samsung S3C24XX series SPI"
-- 
1.7.9.5

