Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaH1Xga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:36:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:35781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbaH1Xg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="473631491"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 03/11] staging/lustre: remove linux/lustre_dlm.h
Date: Thu, 28 Aug 2014 18:35:11 -0500
Message-ID: <1409268919-16155-4-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
References: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.106]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the superfluous header lustre/include/linux/lustre_dlm.h.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 .../lustre/lustre/include/linux/lustre_dlm.h       |   46 --------------------
 drivers/staging/lustre/lustre/include/lustre_dlm.h |    2 -
 2 files changed, 48 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_dlm.h

diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_dlm.h b/drivers/staging/lustre/lustre/include/linux/lustre_dlm.h
deleted file mode 100644
index 207df03..0000000
--- a/drivers/staging/lustre/lustre/include/linux/lustre_dlm.h
+++ /dev/null
@@ -1,46 +0,0 @@
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
- * Copyright (c) 2002, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#ifndef _LINUX_LUSTRE_DLM_H__
-#define _LINUX_LUSTRE_DLM_H__
-
-#ifndef _LUSTRE_DLM_H__
-#error Do not #include this file directly. #include <lprocfs_status.h> instead
-#endif
-
-# include <linux/proc_fs.h>
-#  include <asm/processor.h>
-#  include <linux/bit_spinlock.h>
-
-#endif
diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index 30b1812f..471eef9 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -48,8 +48,6 @@
 #ifndef _LUSTRE_DLM_H__
 #define _LUSTRE_DLM_H__
 
-#include "linux/lustre_dlm.h"
-
 #include "lustre_lib.h"
 #include "lustre_net.h"
 #include "lustre_import.h"
-- 
1.7.9.5

