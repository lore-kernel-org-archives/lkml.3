Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbbAER41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:56:27 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:38004 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608AbbAER4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:24 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 40/45] staging: comedi: rti800: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:55:08 +0000
Message-Id: <1420480513-14765-41-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/rti800.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index 67b4b37..340ac77 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -19,8 +19,7 @@
 /*
  * Driver: rti800
  * Description: Analog Devices RTI-800/815
- * Devices: (Analog Devices) RTI-800 [rti800]
- *	    (Analog Devices) RTI-815 [rti815]
+ * Devices: [Analog Devices] RTI-800 (rti800), RTI-815 (rti815)
  * Author: David A. Schleef <ds@schleef.org>
  * Status: unknown
  * Updated: Fri, 05 Sep 2008 14:50:44 +0100
-- 
2.1.4

