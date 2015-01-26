Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbbAZN0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:26:36 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:48452 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720AbbAZNZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:25:41 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] staging: comedi: 8255.c: reformat comedi driver comment
Date: Mon, 26 Jan 2015 13:25:22 +0000
Message-Id: <1422278725-17740-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
References: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the usual block comment style.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/8255.c | 61 +++++++++++++++++------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index ed1f065..fafe40b 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -17,37 +17,36 @@
  */
 
 /*
-Driver: 8255
-Description: generic 8255 support
-Devices: [standard] 8255 (8255)
-Author: ds
-Status: works
-Updated: Fri,  7 Jun 2002 12:56:45 -0700
-
-The classic in digital I/O.  The 8255 appears in Comedi as a single
-digital I/O subdevice with 24 channels.  The channel 0 corresponds
-to the 8255's port A, bit 0; channel 23 corresponds to port C, bit
-7.  Direction configuration is done in blocks, with channels 0-7,
-8-15, 16-19, and 20-23 making up the 4 blocks.  The only 8255 mode
-supported is mode 0.
-
-You should enable compilation this driver if you plan to use a board
-that has an 8255 chip.  For multifunction boards, the main driver will
-configure the 8255 subdevice automatically.
-
-This driver also works independently with ISA and PCI cards that
-directly map the 8255 registers to I/O ports, including cards with
-multiple 8255 chips.  To configure the driver for such a card, the
-option list should be a list of the I/O port bases for each of the
-8255 chips.  For example,
-
-  comedi_config /dev/comedi0 8255 0x200,0x204,0x208,0x20c
-
-Note that most PCI 8255 boards do NOT work with this driver, and
-need a separate driver as a wrapper.  For those that do work, the
-I/O port base address can be found in the output of 'lspci -v'.
-
-*/
+ * Driver: 8255
+ * Description: generic 8255 support
+ * Devices: [standard] 8255 (8255)
+ * Author: ds
+ * Status: works
+ * Updated: Fri,  7 Jun 2002 12:56:45 -0700
+ *
+ * The classic in digital I/O.  The 8255 appears in Comedi as a single
+ * digital I/O subdevice with 24 channels.  The channel 0 corresponds
+ * to the 8255's port A, bit 0; channel 23 corresponds to port C, bit
+ * 7.  Direction configuration is done in blocks, with channels 0-7,
+ * 8-15, 16-19, and 20-23 making up the 4 blocks.  The only 8255 mode
+ * supported is mode 0.
+ *
+ * You should enable compilation this driver if you plan to use a board
+ * that has an 8255 chip.  For multifunction boards, the main driver will
+ * configure the 8255 subdevice automatically.
+ *
+ * This driver also works independently with ISA and PCI cards that
+ * directly map the 8255 registers to I/O ports, including cards with
+ * multiple 8255 chips.  To configure the driver for such a card, the
+ * option list should be a list of the I/O port bases for each of the
+ * 8255 chips.  For example,
+ *
+ *   comedi_config /dev/comedi0 8255 0x200,0x204,0x208,0x20c
+ *
+ * Note that most PCI 8255 boards do NOT work with this driver, and
+ * need a separate driver as a wrapper.  For those that do work, the
+ * I/O port base address can be found in the output of 'lspci -v'.
+ */
 
 /*
    This file contains an exported subdevice for driving an 8255.
-- 
2.1.4

