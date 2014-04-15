Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaDOKM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:12:28 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:56247 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaDOKMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:12:23 -0400
From: Harini Katakam <harinik@xilinx.com>
To: broonie@kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: michals@xilinx.com, Harini Katakam <harinik@xilinx.com>
Subject: [PATCH v2] spi: cadence: Add dependency on ARCH_ARM
Date: Tue, 15 Apr 2014 15:42:15 +0530
Message-Id: <1397556735-2536-1-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dependency on ARCH_ARM in Kconfig.
This is to fix the build error related to _relaxed IO.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---

v2 changes:
Dependency on ARCH_ARM instead of restricting to ARCH_ZYNQ.

---
 drivers/spi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index b0f091b..32c27dd 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -150,6 +150,7 @@ config SPI_BUTTERFLY
 
 config SPI_CADENCE
 	tristate "Cadence SPI controller"
+	depends on ARCH_ARM
 	depends on SPI_MASTER
 	help
 	  This selects the Cadence SPI controller master driver
-- 
1.7.9.5

