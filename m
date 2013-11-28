Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab3K1EKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:10:41 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63248 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3K1EKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:10:38 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] staging/lustre: remove wirehdr.c
Date: Thu, 28 Nov 2013 12:10:21 +0800
Message-Id: <1385611821-9638-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
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

