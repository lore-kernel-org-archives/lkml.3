Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337AbaLEBR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:17:27 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63654 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbaLEBR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:17:26 -0500
From: Ashley Lai <ashleydlai@gmail.com>
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Ashley Lai <ashleydlai@gmail.com>
Subject: [PATCH 1/1] tpm_ibmvtpm: Update email address in maintainers list and ibmvtpm driver
Date: Thu,  4 Dec 2014 19:17:22 -0600
Message-Id: <1417742242-13016-1-git-send-email-ashleydlai@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added myself as a maintainer for the IBM vtpm driver and removed myself
from the tpm maintainer list. Also, updated the tpm_ibmvtpm driver with
my current email address.

Signed-off-by: Ashley Lai <ashleydlai@gmail.com>
---
 MAINTAINERS                    | 8 +++++++-
 drivers/char/tpm/tpm_ibmvtpm.c | 2 +-
 drivers/char/tpm/tpm_ibmvtpm.h | 2 +-
 drivers/char/tpm/tpm_of.c      | 2 +-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ccb0fef..ddf85b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9297,13 +9297,19 @@ F:	drivers/media/usb/tm6000/
 
 TPM DEVICE DRIVER
 M:	Peter Huewe <peterhuewe@gmx.de>
-M:	Ashley Lai <ashley@ashleylai.com>
 M:	Marcel Selhorst <tpmdd@selhorst.net>
 W:	http://tpmdd.sourceforge.net
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/char/tpm/
 
+IBM VTPM DEVICE DRIVER
+M:	Ashley Lai <ashleydlai@gmail.com>
+W:	http://tpmdd.sourceforge.net
+L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/char/tpm/tpm_ibmvtpm*
+
 TRACING
 M:	Steven Rostedt <rostedt@goodmis.org>
 M:	Ingo Molnar <mingo@redhat.com>
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 4109222..96f5d44 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2012 IBM Corporation
  *
- * Author: Ashley Lai <adlai@us.ibm.com>
+ * Author: Ashley Lai <ashleydlai@gmail.com>
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
diff --git a/drivers/char/tpm/tpm_ibmvtpm.h b/drivers/char/tpm/tpm_ibmvtpm.h
index bd82a79..f595f14 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.h
+++ b/drivers/char/tpm/tpm_ibmvtpm.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2012 IBM Corporation
  *
- * Author: Ashley Lai <adlai@us.ibm.com>
+ * Author: Ashley Lai <ashleydlai@gmail.com>
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 98ba2bd..c002d1b 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -1,7 +1,7 @@
 /*
  * Copyright 2012 IBM Corporation
  *
- * Author: Ashley Lai <adlai@us.ibm.com>
+ * Author: Ashley Lai <ashleydlai@gmail.com>
  *
  * Maintained by: <tpmdd-devel@lists.sourceforge.net>
  *
-- 
1.9.1

