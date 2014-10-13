Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaJMMlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:41:49 -0400
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:40598 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804AbaJMMlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:41:47 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] staging: comedi: cb_pcimdas: use preferred block comment style
Date: Mon, 13 Oct 2014 13:41:20 +0100
Message-Id: <1413204082-14757-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413204082-14757-1-git-send-email-abbotti@mev.co.uk>
References: <1413204082-14757-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the preferred block comment style for the copyright and Comedi
driver description header comments.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 71 +++++++++++++++--------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index fe4d254..804b3c3 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -1,40 +1,41 @@
 /*
-    comedi/drivers/cb_pcimdas.c
-    Comedi driver for Computer Boards PCIM-DAS1602/16
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
+ * comedi/drivers/cb_pcimdas.c
+ * Comedi driver for Computer Boards PCIM-DAS1602/16
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
+
 /*
-Driver: cb_pcimdas
-Description: Measurement Computing PCI Migration series boards
-Devices: [ComputerBoards] PCIM-DAS1602/16 (cb_pcimdas)
-Author: Richard Bytheway
-Updated: Wed, 13 Nov 2002 12:34:56 +0000
-Status: experimental
-
-Written to support the PCIM-DAS1602/16 on a 2.4 series kernel.
-
-Configuration Options:
-    [0] - PCI bus number
-    [1] - PCI slot number
-
-Developed from cb_pcidas and skel by Richard Bytheway (mocelet@sucs.org).
-Only supports DIO, AO and simple AI in it's present form.
-No interrupts, multi channel or FIFO AI,
-although the card looks like it could support this.
-See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more details.
-*/
+ * Driver: cb_pcimdas
+ * Description: Measurement Computing PCI Migration series boards
+ * Devices: [ComputerBoards] PCIM-DAS1602/16 (cb_pcimdas)
+ * Author: Richard Bytheway
+ * Updated: Wed, 13 Nov 2002 12:34:56 +0000
+ * Status: experimental
+ *
+ * Written to support the PCIM-DAS1602/16 on a 2.4 series kernel.
+ *
+ * Configuration Options:
+ *     [0] - PCI bus number
+ *     [1] - PCI slot number
+ *
+ * Developed from cb_pcidas and skel by Richard Bytheway (mocelet@sucs.org).
+ * Only supports DIO, AO and simple AI in it's present form.
+ * No interrupts, multi channel or FIFO AI,
+ * although the card looks like it could support this.
+ * See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more details.
+ */
 
 #include <linux/module.h>
 #include <linux/pci.h>
-- 
2.1.1

