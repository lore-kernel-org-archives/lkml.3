Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbaGYJFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:05:21 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41123 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759850AbaGYJFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:05:16 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] staging: comedi: amplc_pc236: reformat header comments
Date: Fri, 25 Jul 2014 10:04:47 +0100
Message-Id: <1406279098-8498-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
References: <1406279098-8498-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use preferred style for copyright and driver description comments.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pc236.c | 92 ++++++++++++++--------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index 243b0f4..9d64e45 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -1,51 +1,51 @@
 /*
-    comedi/drivers/amplc_pc236.c
-    Driver for Amplicon PC36AT and PCI236 DIO boards.
-
-    Copyright (C) 2002 MEV Ltd. <http://www.mev.co.uk/>
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 2000 David A. Schleef <ds@schleef.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-*/
+ * comedi/drivers/amplc_pc236.c
+ * Driver for Amplicon PC36AT and PCI236 DIO boards.
+ *
+ * Copyright (C) 2002 MEV Ltd. <http://www.mev.co.uk/>
+ *
+ * COMEDI - Linux Control and Measurement Device Interface
+ * Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
 /*
-Driver: amplc_pc236
-Description: Amplicon PC36AT, PCI236
-Author: Ian Abbott <abbotti@mev.co.uk>
-Devices: [Amplicon] PC36AT (pc36at), PCI236 (pci236 or amplc_pc236)
-Updated: Wed, 01 Apr 2009 15:41:25 +0100
-Status: works
-
-Configuration options - PC36AT:
-  [0] - I/O port base address
-  [1] - IRQ (optional)
-
-Configuration options - PCI236:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-  If bus/slot is not specified, the first available PCI device will be
-  used.
-
-The PC36AT ISA board and PCI236 PCI board have a single 8255 appearing
-as subdevice 0.
-
-Subdevice 1 pretends to be a digital input device, but it always returns
-0 when read. However, if you run a command with scan_begin_src=TRIG_EXT,
-a rising edge on port C bit 3 acts as an external trigger, which can be
-used to wake up tasks.  This is like the comedi_parport device, but the
-only way to physically disable the interrupt on the PC36AT is to remove
-the IRQ jumper.  If no interrupt is connected, then subdevice 1 is
-unused.
-*/
+ * Driver: amplc_pc236
+ * Description: Amplicon PC36AT, PCI236
+ * Author: Ian Abbott <abbotti@mev.co.uk>
+ * Devices: [Amplicon] PC36AT (pc36at), PCI236 (pci236 or amplc_pc236)
+ * Updated: Wed, 01 Apr 2009 15:41:25 +0100
+ * Status: works
+ *
+ * Configuration options - PC36AT:
+ *   [0] - I/O port base address
+ *   [1] - IRQ (optional)
+ *
+ * Configuration options - PCI236:
+ *   [0] - PCI bus of device (optional)
+ *   [1] - PCI slot of device (optional)
+ *   If bus/slot is not specified, the first available PCI device will be
+ *   used.
+ *
+ * The PC36AT ISA board and PCI236 PCI board have a single 8255 appearing
+ * as subdevice 0.
+ *
+ * Subdevice 1 pretends to be a digital input device, but it always returns
+ * 0 when read. However, if you run a command with scan_begin_src=TRIG_EXT,
+ * a rising edge on port C bit 3 acts as an external trigger, which can be
+ * used to wake up tasks.  This is like the comedi_parport device, but the
+ * only way to physically disable the interrupt on the PC36AT is to remove
+ * the IRQ jumper.  If no interrupt is connected, then subdevice 1 is
+ * unused.
+ */
 
 #include <linux/module.h>
 #include <linux/pci.h>
-- 
2.0.0

