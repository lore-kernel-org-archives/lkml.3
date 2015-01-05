Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbbAESDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:03:37 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:58916 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218AbbAER4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:08 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/45] staging: comedi: ni_65xx: use board names on "Devices:" line
Date: Mon,  5 Jan 2015 17:54:53 +0000
Message-Id: <1420480513-14765-26-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
References: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the supported devices listed on the "Devices:" line currently use
the comedi driver name as the comedi board name.  Historically, this
documented the name that should be passed to the "comedi_config" program
to "attach" the device via the COMEDI_DEVCONFIG ioctl.  Some drivers
expected the driver name and others expected the board name.  Since this
driver no longer supports the legacy "attach" mechanism, change the
"Devices:" list to show the board names, as that is probably more
useful.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_65xx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 9e8462b..67cb758 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -25,10 +25,14 @@
  * Author: Jon Grierson <jd@renko.co.uk>,
  *	   Frank Mori Hess <fmhess@users.sourceforge.net>
  * Status: testing
- * Devices: [National Instruments] PCI-6509 (ni_65xx), PXI-6509, PCI-6510,
- *   PCI-6511, PXI-6511, PCI-6512, PXI-6512, PCI-6513, PXI-6513, PCI-6514,
- *   PXI-6514, PCI-6515, PXI-6515, PCI-6516, PCI-6517, PCI-6518, PCI-6519,
- *   PCI-6520, PCI-6521, PXI-6521, PCI-6528, PXI-6528
+ * Devices: [National Instruments] PCI-6509 (pci-6509), PXI-6509 (pxi-6509),
+ *   PCI-6510 (pci-6510), PCI-6511 (pci-6511), PXI-6511 (pxi-6511),
+ *   PCI-6512 (pci-6512), PXI-6512 (pxi-6512), PCI-6513 (pci-6513),
+ *   PXI-6513 (pxi-6513), PCI-6514 (pci-6514), PXI-6514 (pxi-6514),
+ *   PCI-6515 (pxi-6515), PXI-6515 (pxi-6515), PCI-6516 (pci-6516),
+ *   PCI-6517 (pci-6517), PCI-6518 (pci-6518), PCI-6519 (pci-6519),
+ *   PCI-6520 (pci-6520), PCI-6521 (pci-6521), PXI-6521 (pxi-6521),
+ *   PCI-6528 (pci-6528), PXI-6528 (pxi-6528)
  * Updated: Mon, 21 Jul 2014 12:49:58 +0000
  *
  * Configuration Options: not applicable, uses PCI auto config
-- 
2.1.4

