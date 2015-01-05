Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbbAESCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:02:42 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:51100 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbbAER4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:11 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 28/45] staging: comedi: ni_labpc_pci: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:54:56 +0000
Message-Id: <1420480513-14765-29-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_labpc_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_pci.c b/drivers/staging/comedi/drivers/ni_labpc_pci.c
index 3fc4204..a9f408a 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_pci.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_pci.c
@@ -17,7 +17,7 @@
 /*
  * Driver: ni_labpc_pci
  * Description: National Instruments Lab-PC PCI-1200
- * Devices: (National Instruments) PCI-1200 [ni_pci-1200]
+ * Devices: [National Instruments] PCI-1200 (ni_pci-1200)
  * Author: Frank Mori Hess <fmhess@users.sourceforge.net>
  * Status: works
  *
-- 
2.1.4

