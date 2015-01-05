Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbbAESGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:06:03 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:41739 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932068AbbAERzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:55 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/45] staging: comedi: das08_pci: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:54:41 +0000
Message-Id: <1420480513-14765-14-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/das08_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das08_pci.c b/drivers/staging/comedi/drivers/das08_pci.c
index 0987ce55..b2ea10b 100644
--- a/drivers/staging/comedi/drivers/das08_pci.c
+++ b/drivers/staging/comedi/drivers/das08_pci.c
@@ -21,7 +21,7 @@
 /*
  * Driver: das08_pci
  * Description: DAS-08 PCI compatible boards
- * Devices: (ComputerBoards) PCI-DAS08 [pci-das08]
+ * Devices: [ComputerBoards] PCI-DAS08 (pci-das08)
  * Author: Warren Jasper, ds, Frank Hess
  * Updated: Fri, 31 Aug 2012 19:19:06 +0100
  * Status: works
-- 
2.1.4

