Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbbAESFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:05:37 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:42890 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932135AbbAERz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:56 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/45] staging: comedi: das16: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:54:42 +0000
Message-Id: <1420480513-14765-15-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/das16.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 2436057..64b0ada 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -22,28 +22,17 @@
  * Driver: das16
  * Description: DAS16 compatible boards
  * Author: Sam Moore, Warren Jasper, ds, Chris Baugher, Frank Hess, Roman Fietze
- * Devices: (Keithley Metrabyte) DAS-16 [das-16]
- *	    (Keithley Metrabyte) DAS-16G [das-16g]
- *	    (Keithley Metrabyte) DAS-16F [das-16f]
- *	    (Keithley Metrabyte) DAS-1201 [das-1201]
- *	    (Keithley Metrabyte) DAS-1202 [das-1202]
- *	    (Keithley Metrabyte) DAS-1401 [das-1401]
- *	    (Keithley Metrabyte) DAS-1402 [das-1402]
- *	    (Keithley Metrabyte) DAS-1601 [das-1601]
- *	    (Keithley Metrabyte) DAS-1602 [das-1602]
- *	    (ComputerBoards) PC104-DAS16/JR [pc104-das16jr]
- *	    (ComputerBoards) PC104-DAS16JR/16 [pc104-das16jr/16]
- *	    (ComputerBoards) CIO-DAS16 [cio-das16]
- *	    (ComputerBoards) CIO-DAS16F [cio-das16/f]
- *	    (ComputerBoards) CIO-DAS16/JR [cio-das16/jr]
- *	    (ComputerBoards) CIO-DAS16JR/16 [cio-das16jr/16]
- *	    (ComputerBoards) CIO-DAS1401/12 [cio-das1401/12]
- *	    (ComputerBoards) CIO-DAS1402/12 [cio-das1402/12]
- *	    (ComputerBoards) CIO-DAS1402/16 [cio-das1402/16]
- *	    (ComputerBoards) CIO-DAS1601/12 [cio-das1601/12]
- *	    (ComputerBoards) CIO-DAS1602/12 [cio-das1602/12]
- *	    (ComputerBoards) CIO-DAS1602/16 [cio-das1602/16]
- *	    (ComputerBoards) CIO-DAS16/330 [cio-das16/330]
+ * Devices: [Keithley Metrabyte] DAS-16 (das-16), DAS-16G (das-16g),
+ *   DAS-16F (das-16f), DAS-1201 (das-1201), DAS-1202 (das-1202),
+ *   DAS-1401 (das-1401), DAS-1402 (das-1402), DAS-1601 (das-1601),
+ *   DAS-1602 (das-1602),
+ *   [ComputerBoards] PC104-DAS16/JR (pc104-das16jr),
+ *   PC104-DAS16JR/16 (pc104-das16jr/16), CIO-DAS16 (cio-das16),
+ *   CIO-DAS16F (cio-das16/f), CIO-DAS16/JR (cio-das16/jr),
+ *   CIO-DAS16JR/16 (cio-das16jr/16), CIO-DAS1401/12 (cio-das1401/12),
+ *   CIO-DAS1402/12 (cio-das1402/12), CIO-DAS1402/16 (cio-das1402/16),
+ *   CIO-DAS1601/12 (cio-das1601/12), CIO-DAS1602/12 (cio-das1602/12),
+ *   CIO-DAS1602/16 (cio-das1602/16), CIO-DAS16/330 (cio-das16/330)
  * Status: works
  * Updated: 2003-10-12
  *
-- 
2.1.4

