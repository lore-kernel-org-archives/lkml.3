Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbaGYJIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:08:55 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41146 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759969AbaGYJFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] staging: comedi: amplc_pc236: remove some boilerplate comments
Date: Fri, 25 Jul 2014 10:04:48 +0100
Message-Id: <1406279098-8498-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 9d64e45..7600319 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -117,10 +117,6 @@ static const struct pc236_board pc236_boards[] = {
 #endif
 };
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.
- */
 struct pc236_private {
 	unsigned long lcr_iobase; /* PLX PCI9052 config registers in PCIBAR1 */
 	int enable_irq;
@@ -425,12 +421,6 @@ static int pc236_pci_common_attach(struct comedi_device *dev,
 	return pc236_common_attach(dev, iobase, pci_dev->irq, IRQF_SHARED);
 }
 
-/*
- * Attach is called by the Comedi core to configure the driver
- * for a particular board.  If you specified a board_name array
- * in the driver structure, dev->board_ptr contains that
- * address.
- */
 static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct pc236_board *thisboard = comedi_board(dev);
@@ -461,11 +451,6 @@ static int pc236_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	return -EINVAL;
 }
 
-/*
- * The auto_attach hook is called at PCI probe time via
- * comedi_pci_auto_config().  dev->board_ptr is NULL on entry.
- * There should be a board entry matching the supplied PCI device.
- */
 static int pc236_auto_attach(struct comedi_device *dev,
 				       unsigned long context_unused)
 {
@@ -517,12 +502,6 @@ static void pc236_detach(struct comedi_device *dev)
 	}
 }
 
-/*
- * The struct comedi_driver structure tells the Comedi core module
- * which functions to call to configure/deconfigure (attach/detach)
- * the board, and also about the kernel module that contains
- * the device code.
- */
 static struct comedi_driver amplc_pc236_driver = {
 	.driver_name = "amplc_pc236",
 	.module = THIS_MODULE,
-- 
2.0.0

