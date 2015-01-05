Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbbAER4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:56:30 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:50280 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932241AbbAER4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:23 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 39/45] staging: comedi: rtd520: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:55:07 +0000
Message-Id: <1420480513-14765-40-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/rtd520.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 581aa58..06ae436 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -19,10 +19,8 @@
 /*
  * Driver: rtd520
  * Description: Real Time Devices PCI4520/DM7520
- * Devices: (Real Time Devices) DM7520HR-1 [DM7520]
- *	    (Real Time Devices) DM7520HR-8 [DM7520]
- *	    (Real Time Devices) PCI4520 [PCI4520]
- *	    (Real Time Devices) PCI4520-8 [PCI4520]
+ * Devices: [Real Time Devices] DM7520HR-1 (DM7520), DM7520HR-8,
+ *   PCI4520 (PCI4520), PCI4520-8
  * Author: Dan Christian
  * Status: Works. Only tested on DM7520-8. Not SMP safe.
  *
-- 
2.1.4

