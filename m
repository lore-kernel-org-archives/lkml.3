Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaH1Xhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:37:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:54933 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaH1Xgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="591404843"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 11/11] staging/lustre: remove linux/obd_support.h
Date: Thu, 28 Aug 2014 18:35:19 -0500
Message-ID: <1409268919-16155-12-git-send-email-john.hammond@intel.com>
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

Remove the superfluous header lustre/include/linux/obd_support.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/obd_support.h      |   63 --------------------
 .../staging/lustre/lustre/include/obd_support.h    |    2 +-
 2 files changed, 1 insertion(+), 64 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/obd_support.h

diff --git a/drivers/staging/lustre/lustre/include/linux/obd_support.h b/drivers/staging/lustre/lustre/include/linux/obd_support.h
deleted file mode 100644
index ea03b84..0000000
--- a/drivers/staging/lustre/lustre/include/linux/obd_support.h
+++ /dev/null
@@ -1,63 +0,0 @@
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
- * Copyright (c) 1999, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, 2012, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef _LINUX_OBD_SUPPORT
-#define _LINUX_OBD_SUPPORT
-
-#ifndef _OBD_SUPPORT
-#error Do not #include this file directly. #include <obd_support.h> instead
-#endif
-
-#ifdef CONFIG_X86
-#include <asm/cpufeature.h>
-#endif
-#include <asm/processor.h>
-#include <linux/seq_file.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/highmem.h>
-#include <linux/swap.h>
-#include "../../include/linux/lustre_compat25.h"
-#include "lustre_common.h"
-#include "../../../include/linux/libcfs/libcfs.h"
-#include "../lustre/lustre_idl.h"
-
-
-# include <linux/types.h>
-# include <linux/blkdev.h>
-# include "../lvfs.h"
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/obd_support.h b/drivers/staging/lustre/lustre/include/obd_support.h
index 874606a..ee36ee5 100644
--- a/drivers/staging/lustre/lustre/include/obd_support.h
+++ b/drivers/staging/lustre/lustre/include/obd_support.h
@@ -37,10 +37,10 @@
 #ifndef _OBD_SUPPORT
 #define _OBD_SUPPORT
 
+#include <linux/slab.h>
 #include "../../include/linux/libcfs/libcfs.h"
 #include "lvfs.h"
 #include "lprocfs_status.h"
-#include "linux/obd_support.h"
 
 /* global variables */
 extern struct lprocfs_stats *obd_memory;
-- 
1.7.9.5

