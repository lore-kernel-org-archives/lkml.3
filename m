Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbbAESBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:01:06 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:49313 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205AbbAER4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:17 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 33/45] staging: comedi: pcl726: rewrite "Devices:" line
Date: Mon,  5 Jan 2015 17:55:01 +0000
Message-Id: <1420480513-14765-34-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/pcl726.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index 86f713f..4079815 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -21,11 +21,8 @@
  * Description: Advantech PCL-726 & compatibles
  * Author: David A. Schleef <ds@schleef.org>
  * Status: untested
- * Devices: (Advantech) PCL-726 [pcl726]
- *	    (Advantech) PCL-727 [pcl727]
- *	    (Advantech) PCL-728 [pcl728]
- *	    (ADLink) ACL-6126 [acl6126]
- *	    (ADLink) ACL-6128 [acl6128]
+ * Devices: [Advantech] PCL-726 (pcl726), PCL-727 (pcl727), PCL-728 (pcl728),
+ *   [ADLink] ACL-6126 (acl6126), ACL-6128 (acl6128)
  *
  * Configuration Options:
  *   [0]  - IO Base
-- 
2.1.4

