Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbbAER6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:58:54 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:38085 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178AbbAER4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:22 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 38/45] staging: comedi: pcmuio: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:55:06 +0000
Message-Id: <1420480513-14765-39-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/pcmuio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 0f5483b..a1641d9 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -19,8 +19,7 @@
 /*
  * Driver: pcmuio
  * Description: Winsystems PC-104 based 48/96-channel DIO boards.
- * Devices: (Winsystems) PCM-UIO48A [pcmuio48]
- *	    (Winsystems) PCM-UIO96A [pcmuio96]
+ * Devices: [Winsystems] PCM-UIO48A (pcmuio48), PCM-UIO96A (pcmuio96)
  * Author: Calin Culianu <calin@ajvar.org>
  * Updated: Fri, 13 Jan 2006 12:01:01 -0500
  * Status: works
-- 
2.1.4

