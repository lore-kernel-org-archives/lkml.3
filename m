Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbbAESBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:01:52 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:42436 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932184AbbAER4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:56:13 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 30/45] staging: comedi: ni_tiocmd: change comedi "driver" comment to "module"
Date: Mon,  5 Jan 2015 17:54:58 +0000
Message-Id: <1420480513-14765-31-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_tiocmd.c | 43 +++++++++++++++---------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tiocmd.c b/drivers/staging/comedi/drivers/ni_tiocmd.c
index 6037bec..d36c3ab 100644
--- a/drivers/staging/comedi/drivers/ni_tiocmd.c
+++ b/drivers/staging/comedi/drivers/ni_tiocmd.c
@@ -16,29 +16,28 @@
 */
 
 /*
-Driver: ni_tiocmd
-Description: National Instruments general purpose counters command support
-Devices:
-Author: J.P. Mellor <jpmellor@rose-hulman.edu>,
-	Herman.Bruyninckx@mech.kuleuven.ac.be,
-	Wim.Meeussen@mech.kuleuven.ac.be,
-	Klaas.Gadeyne@mech.kuleuven.ac.be,
-	Frank Mori Hess <fmhess@users.sourceforge.net>
-Updated: Fri, 11 Apr 2008 12:32:35 +0100
-Status: works
-
-This module is not used directly by end-users.  Rather, it
-is used by other drivers (for example ni_660x and ni_pcimio)
-to provide command support for NI's general purpose counters.
-It was originally split out of ni_tio.c to stop the 'ni_tio'
-module depending on the 'mite' module.
-
-References:
-DAQ 660x Register-Level Programmer Manual  (NI 370505A-01)
-DAQ 6601/6602 User Manual (NI 322137B-01)
-340934b.pdf  DAQ-STC reference manual
+ * Module: ni_tiocmd
+ * Description: National Instruments general purpose counters command support
+ * Author: J.P. Mellor <jpmellor@rose-hulman.edu>,
+ *         Herman.Bruyninckx@mech.kuleuven.ac.be,
+ *         Wim.Meeussen@mech.kuleuven.ac.be,
+ *         Klaas.Gadeyne@mech.kuleuven.ac.be,
+ *         Frank Mori Hess <fmhess@users.sourceforge.net>
+ * Updated: Fri, 11 Apr 2008 12:32:35 +0100
+ * Status: works
+ *
+ * This module is not used directly by end-users.  Rather, it
+ * is used by other drivers (for example ni_660x and ni_pcimio)
+ * to provide command support for NI's general purpose counters.
+ * It was originally split out of ni_tio.c to stop the 'ni_tio'
+ * module depending on the 'mite' module.
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

