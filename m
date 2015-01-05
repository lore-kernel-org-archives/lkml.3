Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbbAESFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:05:00 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:38867 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932144AbbAERz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:57 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/45] staging: comedi: das6402: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:54:43 +0000
Message-Id: <1420480513-14765-16-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/das6402.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index 780f4f6..b8755b5 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -20,8 +20,8 @@
 /*
  * Driver: das6402
  * Description: Keithley Metrabyte DAS6402 (& compatibles)
- * Devices: (Keithley Metrabyte) DAS6402-12 (das6402-12)
- *	    (Keithley Metrabyte) DAS6402-16 (das6402-16)
+ * Devices: [Keithley Metrabyte] DAS6402-12 (das6402-12),
+ *   DAS6402-16 (das6402-16)
  * Author: H Hartley Sweeten <hsweeten@visionengravers.com>
  * Updated: Fri, 14 Mar 2014 10:18:43 -0700
  * Status: unknown
-- 
2.1.4

