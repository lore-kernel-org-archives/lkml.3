Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbbAESGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:06:53 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:36554 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103AbbAERzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:53 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/45] staging: comedi: das08: remove comedi driver comment block
Date: Mon,  5 Jan 2015 17:54:39 +0000
Message-Id: <1420480513-14765-12-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
References: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a module containing common code for the "das08_cs", "das08_isa"
and "das08_pci" comedi drivers.  It does not need its own comedi
"driver" comment block, so remove it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/das08.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index 20a9f0e..c78c0df 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -1,6 +1,6 @@
 /*
  *  comedi/drivers/das08.c
- *  comedi driver for common DAS08 support (used by ISA/PCI/PCMCIA drivers)
+ *  comedi module for common DAS08 support (used by ISA/PCI/PCMCIA drivers)
  *
  *  COMEDI - Linux Control and Measurement Device Interface
  *  Copyright (C) 2000 David A. Schleef <ds@schleef.org>
@@ -18,21 +18,6 @@
  *  GNU General Public License for more details.
  */
 
-/*
- * Driver: das08
- * Description: DAS-08 compatible boards
- * Devices: various, see das08_isa, das08_cs, and das08_pci drivers
- * Author: Warren Jasper, ds, Frank Hess
- * Updated: Fri, 31 Aug 2012 19:19:06 +0100
- * Status: works
- *
- * This driver is used by the das08_isa, das08_cs, and das08_pci
- * drivers to provide the common support for the DAS-08 hardware.
- *
- * The driver doesn't support asynchronous commands, since the
- * cheap das08 hardware doesn't really support them.
- */
-
 #include <linux/module.h>
 
 #include "../comedidev.h"
-- 
2.1.4

