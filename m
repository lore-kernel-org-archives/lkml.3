Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162309AbaDCG0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:26:13 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:60012 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162290AbaDCG0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:26:11 -0400
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, jsvogt@de.ibm.com,
        mijung@gmx.net, michael@ibmra.de, esa@de.ibm.com,
        haver@linux.vnet.ibm.com
Subject: [PATCH] GenWQE: Fix email address and update copyright notice
Date: Thu,  3 Apr 2014 08:25:27 +0200
Message-Id: <1396506327-15015-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040306-4966-0000-0000-000008F1478F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated email address of co-author and updated the copyright notice
with the current year.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
Signed-off-by: Michael Jung <mijung@gmx.net>
---
 drivers/misc/genwqe/card_base.c         |    6 +++---
 drivers/misc/genwqe/card_base.h         |    4 ++--
 drivers/misc/genwqe/card_ddcb.c         |    4 ++--
 drivers/misc/genwqe/card_ddcb.h         |    4 ++--
 drivers/misc/genwqe/card_debugfs.c      |    4 ++--
 drivers/misc/genwqe/card_dev.c          |    4 ++--
 drivers/misc/genwqe/card_sysfs.c        |    4 ++--
 drivers/misc/genwqe/card_utils.c        |    4 ++--
 drivers/misc/genwqe/genwqe_driver.h     |    4 ++--
 include/uapi/linux/genwqe/genwqe_card.h |    4 ++--
 10 files changed, 21 insertions(+), 21 deletions(-)

--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -1,11 +1,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -46,7 +46,7 @@
 MODULE_AUTHOR("Frank Haverkamp <haver@linux.vnet.ibm.com>");
 MODULE_AUTHOR("Michael Ruettger <michael@ibmra.de>");
 MODULE_AUTHOR("Joerg-Stephan Vogt <jsvogt@de.ibm.com>");
-MODULE_AUTHOR("Michal Jung <mijung@de.ibm.com>");
+MODULE_AUTHOR("Michael Jung <mijung@gmx.net>");
 
 MODULE_DESCRIPTION("GenWQE Card");
 MODULE_VERSION(DRV_VERS_STRING);
--- a/drivers/misc/genwqe/card_base.h
+++ b/drivers/misc/genwqe/card_base.h
@@ -4,11 +4,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify
--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -1,11 +1,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify
--- a/drivers/misc/genwqe/card_ddcb.h
+++ b/drivers/misc/genwqe/card_ddcb.h
@@ -4,11 +4,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify
--- a/drivers/misc/genwqe/card_debugfs.c
+++ b/drivers/misc/genwqe/card_debugfs.c
@@ -1,11 +1,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify
--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -1,11 +1,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify
--- a/drivers/misc/genwqe/card_sysfs.c
+++ b/drivers/misc/genwqe/card_sysfs.c
@@ -1,11 +1,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -1,11 +1,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify
--- a/drivers/misc/genwqe/genwqe_driver.h
+++ b/drivers/misc/genwqe/genwqe_driver.h
@@ -4,11 +4,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify
--- a/include/uapi/linux/genwqe/genwqe_card.h
+++ b/include/uapi/linux/genwqe/genwqe_card.h
@@ -4,11 +4,11 @@
 /**
  * IBM Accelerator Family 'GenWQE'
  *
- * (C) Copyright IBM Corp. 2013
+ * (C) Copyright IBM Corp. 2013, 2014
  *
  * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
  * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
- * Author: Michael Jung <mijung@de.ibm.com>
+ * Author: Michael Jung <mijung@gmx.net>
  * Author: Michael Ruettger <michael@ibmra.de>
  *
  * This program is free software; you can redistribute it and/or modify

