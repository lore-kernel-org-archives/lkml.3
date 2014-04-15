Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaDOEuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:50:03 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:46175 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaDOEuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:50:01 -0400
From: Harini Katakam <harinik@xilinx.com>
To: broonie@kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: michals@xilinx.com, Harini Katakam <harinik@xilinx.com>
Subject: [PATCH] spi: cadence: Add dependency on ARCH_ZYNQ
Date: Tue, 15 Apr 2014 10:19:52 +0530
Message-Id: <1397537392-3709-1-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dependency on ARCH_ZYNQ in Kconfig.
This is to fix the build error.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---
 drivers/spi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index b0f091b..0db219b 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -150,6 +150,7 @@ config SPI_BUTTERFLY
 
 config SPI_CADENCE
 	tristate "Cadence SPI controller"
+	depends on ARCH_ZYNQ
 	depends on SPI_MASTER
 	help
 	  This selects the Cadence SPI controller master driver
-- 
1.7.9.5

