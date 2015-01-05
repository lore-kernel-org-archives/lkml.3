Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbbAERz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:55:58 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:56690 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932112AbbAERzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:54 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/45] staging: comedi: das08_isa: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:54:40 +0000
Message-Id: <1420480513-14765-13-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/das08_isa.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_isa.c b/drivers/staging/comedi/drivers/das08_isa.c
index e4ba268..2d9a31d 100644
--- a/drivers/staging/comedi/drivers/das08_isa.c
+++ b/drivers/staging/comedi/drivers/das08_isa.c
@@ -21,18 +21,12 @@
 /*
  * Driver: das08_isa
  * Description: DAS-08 ISA/PC-104 compatible boards
- * Devices: (Keithley Metrabyte) DAS08 [isa-das08],
- *	    (ComputerBoards) DAS08 [isa-das08]
- *	    (ComputerBoards) DAS08-PGM [das08-pgm]
- *	    (ComputerBoards) DAS08-PGH [das08-pgh]
- *	    (ComputerBoards) DAS08-PGL [das08-pgl]
- *	    (ComputerBoards) DAS08-AOH [das08-aoh]
- *	    (ComputerBoards) DAS08-AOL [das08-aol]
- *	    (ComputerBoards) DAS08-AOM [das08-aom]
- *	    (ComputerBoards) DAS08/JR-AO [das08/jr-ao]
- *	    (ComputerBoards) DAS08/JR-16-AO [das08jr-16-ao]
- *	    (ComputerBoards) PC104-DAS08 [pc104-das08]
- *	    (ComputerBoards) DAS08/JR/16 [das08jr/16]
+ * Devices: [Keithley Metrabyte] DAS08 (isa-das08),
+ *   [ComputerBoards] DAS08 (isa-das08), DAS08-PGM (das08-pgm),
+ *   DAS08-PGH (das08-pgh), DAS08-PGL (das08-pgl), DAS08-AOH (das08-aoh),
+ *   DAS08-AOL (das08-aol), DAS08-AOM (das08-aom), DAS08/JR-AO (das08/jr-ao),
+ *   DAS08/JR-16-AO (das08jr-16-ao), PC104-DAS08 (pc104-das08),
+ *   DAS08/JR/16 (das08jr/16)
  * Author: Warren Jasper, ds, Frank Hess
  * Updated: Fri, 31 Aug 2012 19:19:06 +0100
  * Status: works
-- 
2.1.4

