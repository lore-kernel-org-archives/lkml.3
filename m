Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbbAESEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:04:05 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:47948 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159AbbAER4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:00 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/45] staging: comedi: dyna_pci10xx: rewrite comedi driver comment block
Date: Mon,  5 Jan 2015 17:54:46 +0000
Message-Id: <1420480513-14765-19-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
References: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the comedi "driver" comment block to conform to the usual format
for comedi driver comment blocks and reformat it to use the usual block
comment style.  In particular, the "Devices:" line should be a
comma-separated list where the first item is in the following format:

  [Manufacturer] BOARD-NAME (comedi-board-name)

The "[Manufacturer]" and/or "(comedi-board-name)" parts may be omitted
from following items, in which case the parts from the preceding item
are used.  The "Devices:" line may be continued continued over several
lines by using one or more spaces at the start of each continuation line
(not counting the space after the "*" in the block comment).

Change the original "Devices:" line to a "Description:" line.

Remove the "Version:" line as we don't care about driver version numbers
in the kernel.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 35 +++++++++++++--------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 1b6324c..6c1e442 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -14,24 +14,23 @@
  */
 
 /*
- Driver: dyna_pci10xx
- Devices: Dynalog India PCI DAQ Cards, http://www.dynalogindia.com/
- Author: Prashant Shah <pshah.mumbai@gmail.com>
- Developed at Automation Labs, Chemical Dept., IIT Bombay, India.
- Prof. Kannan Moudgalya <kannan@iitb.ac.in>
- http://www.iitb.ac.in
- Status: Stable
- Version: 1.0
- Device Supported :
- - Dynalog PCI 1050
-
- Notes :
- - Dynalog India Pvt. Ltd. does not have a registered PCI Vendor ID and
- they are using the PLX Technlogies Vendor ID since that is the PCI Chip used
- in the card.
- - Dynalog India Pvt. Ltd. has provided the internal register specification for
- their cards in their manuals.
-*/
+ * Driver: dyna_pci10xx
+ * Description: Dynalog India PCI DAQ Cards, http://www.dynalogindia.com/
+ * Devices: [Dynalog] PCI-1050 (dyna_pci1050)
+ * Author: Prashant Shah <pshah.mumbai@gmail.com>
+ * Status: Stable
+ *
+ * Developed at Automation Labs, Chemical Dept., IIT Bombay, India.
+ * Prof. Kannan Moudgalya <kannan@iitb.ac.in>
+ * http://www.iitb.ac.in
+ *
+ * Notes :
+ * - Dynalog India Pvt. Ltd. does not have a registered PCI Vendor ID and
+ *   they are using the PLX Technlogies Vendor ID since that is the PCI Chip
+ *   used in the card.
+ * - Dynalog India Pvt. Ltd. has provided the internal register specification
+ *   for their cards in their manuals.
+ */
 
 #include <linux/module.h>
 #include <linux/delay.h>
-- 
2.1.4

