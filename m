Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab3GWURs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:17:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48749 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab3GWURr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:17:47 -0400
Date: Tue, 23 Jul 2013 15:17:27 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] rsxx: Adapter name change.
Message-ID: <20130723201727.GB12914@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072320-2398-0000-0000-000000AC1F76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Changed the device name to IBM Flash Adapter 90 (PCIe2 0.9TB).

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/Kconfig linux-block/drivers/block/Kconfig
--- linux-block-vanilla/drivers/block/Kconfig	2013-06-19 09:04:09.973166155 -0500
+++ linux-block/drivers/block/Kconfig	2013-07-23 10:06:27.077463409 -0500
@@ -532,11 +532,11 @@ config BLK_DEV_RBD
 	  If unsure, say N.
 
 config BLK_DEV_RSXX
-	tristate "IBM Flash Adapter 900GB Full Height PCIe Device Driver"
+	tristate "IBM Flash Adapter 90 (PCIe2 0.9TB)"
 	depends on PCI
 	help
 	  Device driver for IBM's high speed PCIe SSD
-	  storage device: Flash Adapter 900GB Full Height.
+	  storage device: Flash Adapter 90 (PCIe2 0.9TB).
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rsxx.
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-06-19 09:04:09.979153127 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-07-23 10:10:01.395462358 -0500
@@ -43,7 +43,7 @@
 #define NO_LEGACY 0
 #define SYNC_START_TIMEOUT (10 * 60) /* 10 minutes */
 
-MODULE_DESCRIPTION("IBM Flash Adapter 900GB Full Height Device Driver");
+MODULE_DESCRIPTION("IBM Flash Adapter 90 (PCIe2 0.9TB)");
 MODULE_AUTHOR("Joshua Morris/Philip Kelleher, IBM");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRIVER_VERSION);
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/MAINTAINERS linux-block/MAINTAINERS
--- linux-block-vanilla/MAINTAINERS	2013-07-23 09:45:47.552459564 -0500
+++ linux-block/MAINTAINERS	2013-07-23 10:05:01.493460798 -0500
@@ -3355,7 +3355,7 @@ F:	Documentation/firmware_class/
 F:	drivers/base/firmware*.c
 F:	include/linux/firmware.h
 
-FLASH ADAPTER DRIVER (IBM Flash Adapter 900GB Full Height PCI Flash Card)
+FLASH ADAPTER DRIVER (IBM Flash Adapter 90 (PCIe2 0.9TB))
 M:	Joshua Morris <josh.h.morris@us.ibm.com>
 M:	Philip Kelleher <pjk1939@linux.vnet.ibm.com>
 S:	Maintained

