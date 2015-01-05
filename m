Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbbAESEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:04:44 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:54330 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551AbbAERz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:59 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/45] staging: comedi: dt282x: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:54:45 +0000
Message-Id: <1420480513-14765-18-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/dt282x.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 2be98bb..cfa0f97 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -20,22 +20,12 @@
  * Driver: dt282x
  * Description: Data Translation DT2821 series (including DT-EZ)
  * Author: ds
- * Devices: (Data Translation) DT2821 [dt2821]
- *	    (Data Translation) DT2821-F-16SE [dt2821-f]
- *	    (Data Translation) DT2821-F-8DI [dt2821-f]
- *	    (Data Translation) DT2821-G-16SE [dt2821-g]
- *	    (Data Translation) DT2821-G-8DI [dt2821-g]
- *	    (Data Translation) DT2823 [dt2823]
- *	    (Data Translation) DT2824-PGH [dt2824-pgh]
- *	    (Data Translation) DT2824-PGL [dt2824-pgl]
- *	    (Data Translation) DT2825 [dt2825]
- *	    (Data Translation) DT2827 [dt2827]
- *	    (Data Translation) DT2828 [dt2828]
- *	    (Data Translation) DT2928 [dt2829]
- *	    (Data Translation) DT21-EZ [dt21-ez]
- *	    (Data Translation) DT23-EZ [dt23-ez]
- *	    (Data Translation) DT24-EZ [dt24-ez]
- *	    (Data Translation) DT24-EZ-PGL [dt24-ez-pgl]
+ * Devices: [Data Translation] DT2821 (dt2821), DT2821-F-16SE (dt2821-f),
+ *   DT2821-F-8DI (dt2821-f), DT2821-G-16SE (dt2821-g),
+ *   DT2821-G-8DI (dt2821-g), DT2823 (dt2823), DT2824-PGH (dt2824-pgh),
+ *   DT2824-PGL (dt2824-pgl), DT2825 (dt2825), DT2827 (dt2827),
+ *   DT2828 (dt2828), DT2928 (dt2829), DT21-EZ (dt21-ez), DT23-EZ (dt23-ez),
+ *   DT24-EZ (dt24-ez), DT24-EZ-PGL (dt24-ez-pgl)
  * Status: complete
  * Updated: Wed, 22 Aug 2001 17:11:34 -0700
  *
-- 
2.1.4

