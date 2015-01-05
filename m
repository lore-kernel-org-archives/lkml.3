Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbbAER6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:58:14 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:49497 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250AbbAER40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:26 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 42/45] staging: comedi: usbdux: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:55:10 +0000
Message-Id: <1420480513-14765-43-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/usbdux.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 4737dbf..0683d6a 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -16,10 +16,11 @@
 /*
  * Driver: usbdux
  * Description: University of Stirling USB DAQ & INCITE Technology Limited
- * Devices: (ITL) USB-DUX [usbdux]
+ * Devices: [ITL] USB-DUX (usbdux)
  * Author: Bernd Porr <mail@berndporr.me.uk>
  * Updated: 10 Oct 2014
  * Status: Stable
+ *
  * Connection scheme for the counter at the digital port:
  * 0=/CLK0, 1=UP/DOWN0, 2=RESET0, 4=/CLK1, 5=UP/DOWN1, 6=RESET1.
  * The sampling rate of the counter is approximately 500Hz.
-- 
2.1.4

