Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3LCOSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:18:31 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:37923 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3LCOS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:18:27 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-RESEND 2/2] staging/lustre: remove wirehdr.c
Date: Tue,  3 Dec 2013 22:11:39 +0800
Message-Id: <1386079899-7292-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079899-7292-1-git-send-email-bergwolf@gmail.com>
References: <1386079899-7292-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/wirehdr.c |   47 ------------------------
 1 file changed, 47 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/wirehdr.c

diff --git a/drivers/staging/lustre/lustre/ptlrpc/wirehdr.c b/drivers/staging/lustre/lustre/ptlrpc/wirehdr.c
deleted file mode 100644
index 93bc40b..0000000
--- a/drivers/staging/lustre/lustre/ptlrpc/wirehdr.c
+++ /dev/null
@@ -1,47 +0,0 @@
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
- * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
- * Use is subject to license terms.
- *
- * Copyright (c) 2011, Intel Corporation.
- */
-/*
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-#define DEBUG_SUBSYSTEM S_RPC
-
-# ifdef CONFIG_FS_POSIX_ACL
-#  include <linux/fs.h>
-#  include <linux/posix_acl_xattr.h>
-# endif
-
-#include <obd_support.h>
-#include <obd_class.h>
-#include <lustre_net.h>
-#include <lustre_disk.h>
-- 
1.7.9.5

