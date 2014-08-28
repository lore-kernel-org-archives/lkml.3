Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaH1Xgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:36:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:36134 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaH1Xgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378412858"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 07/11] staging/lustre: remove linux/lustre_log.h
Date: Thu, 28 Aug 2014 18:35:15 -0500
Message-ID: <1409268919-16155-8-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
References: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the superfluous header lustre/include/linux/lustre_log.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/lustre_log.h       |   57 --------------------
 drivers/staging/lustre/lustre/include/lustre_log.h |    2 -
 2 files changed, 59 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_log.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_log.h b/drivers/staging/lustre/lustre/include/linux/lustre_log.h
deleted file mode 100644
index e9c8e56..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lustre_log.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
- * GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see
- * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
- *
- * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
- * CA 95054 USA or visit www.sun.com if you need additional information or
- * have any questions.
- *
- * GPL HEADER END
- */
-/*
- * Copyright (c) 2003, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- *
- * lustre/include/linux/lustre_log.h
- *
- * Generic infrastructure for managing a collection of logs.
- * These logs are used for:
- *  - orphan recovery: OST adds record on create
- *  - mtime/size consistency: the OST adds a record on first write
- *  - open/unlinked objects: OST adds a record on destroy
- *
- *  - mds unlink log: the MDS adds an entry upon delete
- *
- *  - raid1 replication log between OST's
- *  - MDS replication logs
- */
-
-#ifndef _LINUX_LUSTRE_LOG_H
-#define _LINUX_LUSTRE_LOG_H
-
-#ifndef _LUSTRE_LOG_H
-#error Do not #include this file directly. #include <lustre_log.h> instead
-#endif
-
-#define LUSTRE_LOG_SERVER
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/lustre_log.h b/drivers/staging/lustre/lustre/include/lustre_log.h
index d02ea24..3932505 100644
--- a/drivers/staging/lustre/lustre/include/lustre_log.h
+++ b/drivers/staging/lustre/lustre/include/lustre_log.h
@@ -56,8 +56,6 @@
  * @{
  */
 
-#include "linux/lustre_log.h"
-
 #include "obd_class.h"
 #include "obd_ost.h"
 #include "lustre/lustre_idl.h"
-- 
1.7.9.5

