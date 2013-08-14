Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab3HNVfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:35:25 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35045 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab3HNVfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:35:24 -0400
Date: Wed, 14 Aug 2013 16:35:17 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 3/5] rsxx: Adapter name change.
Message-ID: <20130814213517.GD26562@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081421-5518-0000-0000-000011380088
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Changed the device name to IBM Flash Adapter 90 (PCIe2 0.9TB).

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/Kconfig linux-block/drivers/block/Kconfig
--- linux-block-vanilla/drivers/block/Kconfig	2013-08-12 14:59:32.477858967 -0500
+++ linux-block/drivers/block/Kconfig	2013-08-12 15:26:22.835861555 -0500
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
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-08-12 15:24:58.069861012 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-08-12 15:26:22.840881367 -0500
@@ -43,7 +43,7 @@
 #define NO_LEGACY 0
 #define SYNC_START_TIMEOUT (10 * 60) /* 10 minutes */
 
-MODULE_DESCRIPTION("IBM Flash Adapter 900GB Full Height Device Driver");
+MODULE_DESCRIPTION("IBM Flash Adapter 90 (PCIe2 0.9TB)");
 MODULE_AUTHOR("Joshua Morris/Philip Kelleher, IBM");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRIVER_VERSION);
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/MAINTAINERS linux-block/MAINTAINERS
--- linux-block-vanilla/MAINTAINERS	2013-08-12 14:59:32.418859778 -0500
+++ linux-block/MAINTAINERS	2013-08-12 15:26:22.844921156 -0500
@@ -3355,7 +3355,7 @@ F:	Documentation/firmware_class/
 F:	drivers/base/firmware*.c
 F:	include/linux/firmware.h
 
-FLASH ADAPTER DRIVER (IBM Flash Adapter 900GB Full Height PCI Flash Card)
+FLASH ADAPTER DRIVER (IBM Flash Adapter 90 (PCIe2 0.9TB))
 M:	Joshua Morris <josh.h.morris@us.ibm.com>
 M:	Philip Kelleher <pjk1939@linux.vnet.ibm.com>
 S:	Maintained

