Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbbAER4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:56:53 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:59756 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932271AbbAER43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:29 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 45/45] staging: comedi: vm80xx: rewrite comedi driver comment block
Date: Mon,  5 Jan 2015 17:55:13 +0000
Message-Id: <1420480513-14765-46-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
References: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the comedi "driver" comment block to conform to the usual format
for comedi driver comment blocks and reformat it to use the usual block
comment style.  In particular, the "Devices:" line should be a
comma-separated list where the first item is in the following format:

  [Manufacturer] BOARD-NAME (comedi-board-name)

The "[Manufacturer]" and/or "(comedi-board-name)" parts may be omitted
from following items, in which case the parts from the preceding item
are used.  The "Devices:" line may be continued continued over several
lines by using one or more spaces at the start of each continuation line
(not counting the space after the "*" in the block comment).

Note that the comedi board names I've added to the "Devices:" line don't
quite match the board names reported by the driver itself, as they
contain parentheses and I don't want nested parentheses on the
"Devices:" line (mostly because it confuses a script I use to extract
supported devices from the driver comments).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/vmk80xx.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index a19a56e..5312e0f 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -18,21 +18,22 @@
     GNU General Public License for more details.
 */
 /*
-Driver: vmk80xx
-Description: Velleman USB Board Low-Level Driver
-Devices: K8055/K8061 aka VM110/VM140
-Author: Manuel Gebele <forensixs@gmx.de>
-Updated: Sun, 10 May 2009 11:14:59 +0200
-Status: works
-
-Supports:
- - analog input
- - analog output
- - digital input
- - digital output
- - counter
- - pwm
-*/
+ * Driver: vmk80xx
+ * Description: Velleman USB Board Low-Level Driver
+ * Devices: [Velleman] K8055 (K8055/VM110), K8061 (K8061/VM140),
+ *   VM110 (K8055/VM110), VM140 (K8061/VM140)
+ * Author: Manuel Gebele <forensixs@gmx.de>
+ * Updated: Sun, 10 May 2009 11:14:59 +0200
+ * Status: works
+ *
+ * Supports:
+ *  - analog input
+ *  - analog output
+ *  - digital input
+ *  - digital output
+ *  - counter
+ *  - pwm
+ */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-- 
2.1.4

