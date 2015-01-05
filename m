Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbbAESCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:02:13 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:46064 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181AbbAER4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:12 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/45] staging: comedi: ni_tio: change comedi "driver" comment to "module"
Date: Mon,  5 Jan 2015 17:54:57 +0000
Message-Id: <1420480513-14765-30-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
References: <1420480513-14765-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module contains support code for some other comedi drivers, but
isn't a comedi driver itself, so doesn't need a comedi "driver" comment.
To preserve the details in the original comment, change it into a comedi
"module" comment (which I've just invented) by changing the "Driver:"
line into a "Module:" line and removing the "Devices:" line.

Also reformat it to use the usual block comment style.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_tio.c | 43 ++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tio.c b/drivers/staging/comedi/drivers/ni_tio.c
index 0525292..c20c51b 100644
--- a/drivers/staging/comedi/drivers/ni_tio.c
+++ b/drivers/staging/comedi/drivers/ni_tio.c
@@ -16,29 +16,28 @@
 */
 
 /*
-Driver: ni_tio
-Description: National Instruments general purpose counters
-Devices:
-Author: J.P. Mellor <jpmellor@rose-hulman.edu>,
-	Herman.Bruyninckx@mech.kuleuven.ac.be,
-	Wim.Meeussen@mech.kuleuven.ac.be,
-	Klaas.Gadeyne@mech.kuleuven.ac.be,
-	Frank Mori Hess <fmhess@users.sourceforge.net>
-Updated: Thu Nov 16 09:50:32 EST 2006
-Status: works
-
-This module is not used directly by end-users.  Rather, it
-is used by other drivers (for example ni_660x and ni_pcimio)
-to provide support for NI's general purpose counters.  It was
-originally based on the counter code from ni_660x.c and
-ni_mio_common.c.
-
-References:
-DAQ 660x Register-Level Programmer Manual  (NI 370505A-01)
-DAQ 6601/6602 User Manual (NI 322137B-01)
-340934b.pdf  DAQ-STC reference manual
+ * Module: ni_tio
+ * Description: National Instruments general purpose counters
+ * Author: J.P. Mellor <jpmellor@rose-hulman.edu>,
+ *         Herman.Bruyninckx@mech.kuleuven.ac.be,
+ *         Wim.Meeussen@mech.kuleuven.ac.be,
+ *         Klaas.Gadeyne@mech.kuleuven.ac.be,
+ *         Frank Mori Hess <fmhess@users.sourceforge.net>
+ * Updated: Thu Nov 16 09:50:32 EST 2006
+ * Status: works
+ *
+ * This module is not used directly by end-users.  Rather, it
+ * is used by other drivers (for example ni_660x and ni_pcimio)
+ * to provide support for NI's general purpose counters.  It was
+ * originally based on the counter code from ni_660x.c and
+ * ni_mio_common.c.
+ *
+ * References:
+ * DAQ 660x Register-Level Programmer Manual  (NI 370505A-01)
+ * DAQ 6601/6602 User Manual (NI 322137B-01)
+ * 340934b.pdf  DAQ-STC reference manual
+ */
 
-*/
 /*
 TODO:
 	Support use of both banks X and Y
-- 
2.1.4

