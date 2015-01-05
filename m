Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbbAESHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:07:48 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:47914 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012AbbAERzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:50 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/45] staging: comedi: cb_pcidda: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:54:36 +0000
Message-Id: <1420480513-14765-9-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/cb_pcidda.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 01875d7..2b2cfcd 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -22,12 +22,10 @@
 /*
  * Driver: cb_pcidda
  * Description: MeasurementComputing PCI-DDA series
- * Devices: (Measurement Computing) PCI-DDA08/12 [pci-dda08/12]
- *	    (Measurement Computing) PCI-DDA04/12 [pci-dda04/12]
- *	    (Measurement Computing) PCI-DDA02/12 [pci-dda02/12]
- *	    (Measurement Computing) PCI-DDA08/16 [pci-dda08/16]
- *	    (Measurement Computing) PCI-DDA04/16 [pci-dda04/16]
- *	    (Measurement Computing) PCI-DDA02/16 [pci-dda02/16]
+ * Devices: [Measurement Computing] PCI-DDA08/12 (pci-dda08/12),
+ *   PCI-DDA04/12 (pci-dda04/12), PCI-DDA02/12 (pci-dda02/12),
+ *   PCI-DDA08/16 (pci-dda08/16), PCI-DDA04/16 (pci-dda04/16),
+ *   PCI-DDA02/16 (pci-dda02/16)
  * Author: Ivan Martinez <ivanmr@altavista.com>
  *	   Frank Mori Hess <fmhess@users.sourceforge.net>
  * Status: works
-- 
2.1.4

