Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbbAESBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:01:32 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:42436 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932198AbbAER4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:15 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 32/45] staging: comedi: pcl724: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:55:00 +0000
Message-Id: <1420480513-14765-33-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/pcl724.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl724.c b/drivers/staging/comedi/drivers/pcl724.c
index fcc4408..74b07e1 100644
--- a/drivers/staging/comedi/drivers/pcl724.c
+++ b/drivers/staging/comedi/drivers/pcl724.c
@@ -8,14 +8,10 @@
 /*
  * Driver: pcl724
  * Description: Comedi driver for 8255 based ISA DIO boards
- * Devices: (Advantech) PCL-724 [pcl724]
- *	    (Advantech) PCL-722 [pcl722]
- *	    (Advantech) PCL-731 [pcl731]
- *	    (ADLink) ACL-7122 [acl7122]
- *	    (ADLink) ACL-7124 [acl7124]
- *	    (ADLink) PET-48DIO [pet48dio]
- *	    (WinSystems) PCM-IO48 [pcmio48]
- *	    (Diamond Systems) ONYX-MM-DIO [onyx-mm-dio]
+ * Devices: [Advantech] PCL-724 (pcl724), PCL-722 (pcl722), PCL-731 (pcl731),
+ *  [ADLink] ACL-7122 (acl7122), ACL-7124 (acl7124), PET-48DIO (pet48dio),
+ *  [WinSystems] PCM-IO48 (pcmio48),
+ *  [Diamond Systems] ONYX-MM-DIO (onyx-mm-dio)
  * Author: Michal Dobes <dobes@tesnet.cz>
  * Status: untested
  *
-- 
2.1.4

