Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbbAER4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:56:17 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:56910 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754204AbbAER4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:07 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/45] staging: comedi: ni_65xx: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:54:52 +0000
Message-Id: <1420480513-14765-25-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
References: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the "Devices:" line in the comedi "driver" comment to conform to
the usual comedi format for this line.  The line should be a
comma-separated list where the first item is in the following format:

  [Manufacturer] BOARD-NAME (comedi-board-name)

The "[Manufacturer]" and/or "(comedi-board-name)" parts may be omitted
from following items, in which case the parts from the preceding item
are used.  The "Devices:" line may be continued continued over several
lines by using one or more spaces at the start of each continuation line
(not counting the space after the "*" in the block comment).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_65xx.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index bcb326e..9e8462b 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -25,28 +25,10 @@
  * Author: Jon Grierson <jd@renko.co.uk>,
  *	   Frank Mori Hess <fmhess@users.sourceforge.net>
  * Status: testing
- * Devices: (National Instruments) PCI-6509 [ni_65xx]
- *	    (National Instruments) PXI-6509 [ni_65xx]
- *	    (National Instruments) PCI-6510 [ni_65xx]
- *	    (National Instruments) PCI-6511 [ni_65xx]
- *	    (National Instruments) PXI-6511 [ni_65xx]
- *	    (National Instruments) PCI-6512 [ni_65xx]
- *	    (National Instruments) PXI-6512 [ni_65xx]
- *	    (National Instruments) PCI-6513 [ni_65xx]
- *	    (National Instruments) PXI-6513 [ni_65xx]
- *	    (National Instruments) PCI-6514 [ni_65xx]
- *	    (National Instruments) PXI-6514 [ni_65xx]
- *	    (National Instruments) PCI-6515 [ni_65xx]
- *	    (National Instruments) PXI-6515 [ni_65xx]
- *	    (National Instruments) PCI-6516 [ni_65xx]
- *	    (National Instruments) PCI-6517 [ni_65xx]
- *	    (National Instruments) PCI-6518 [ni_65xx]
- *	    (National Instruments) PCI-6519 [ni_65xx]
- *	    (National Instruments) PCI-6520 [ni_65xx]
- *	    (National Instruments) PCI-6521 [ni_65xx]
- *	    (National Instruments) PXI-6521 [ni_65xx]
- *	    (National Instruments) PCI-6528 [ni_65xx]
- *	    (National Instruments) PXI-6528 [ni_65xx]
+ * Devices: [National Instruments] PCI-6509 (ni_65xx), PXI-6509, PCI-6510,
+ *   PCI-6511, PXI-6511, PCI-6512, PXI-6512, PCI-6513, PXI-6513, PCI-6514,
+ *   PXI-6514, PCI-6515, PXI-6515, PCI-6516, PCI-6517, PCI-6518, PCI-6519,
+ *   PCI-6520, PCI-6521, PXI-6521, PCI-6528, PXI-6528
  * Updated: Mon, 21 Jul 2014 12:49:58 +0000
  *
  * Configuration Options: not applicable, uses PCI auto config
-- 
2.1.4

