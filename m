Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbbAESDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:03:01 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:49362 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240AbbAER4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:09 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/45] staging: comedi: ni_at_ao: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:54:54 +0000
Message-Id: <1420480513-14765-27-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_at_ao.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 05370a4..9eeaf3c 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -19,8 +19,7 @@
 /*
  * Driver: ni_at_ao
  * Description: National Instruments AT-AO-6/10
- * Devices: (National Instruments) AT-AO-6 [at-ao-6]
- *          (National Instruments) AT-AO-10 [at-ao-10]
+ * Devices: [National Instruments] AT-AO-6 (at-ao-6), AT-AO-10 (at-ao-10)
  * Status: should work
  * Author: David A. Schleef <ds@schleef.org>
  * Updated: Sun Dec 26 12:26:28 EST 2004
-- 
2.1.4

