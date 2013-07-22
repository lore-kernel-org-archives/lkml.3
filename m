Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab3GVQS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:18:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40394 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab3GVQM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:12:28 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 32/48] staging/lustre/lnet: remove empty file lnet/lnet/api-errno.c
Date: Tue, 23 Jul 2013 00:06:53 +0800
Message-Id: <1374509230-3324-33-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@emc.com>

The file is empty. We can just remove it.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2335
Lustre-change: http://review.whamcloud.com/5880
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Li Wei <wei.g.li@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/lnet/Makefile    |    2 +-
 drivers/staging/lustre/lnet/lnet/api-errno.c |   39 --------------------------
 2 files changed, 1 insertion(+), 40 deletions(-)
 delete mode 100644 drivers/staging/lustre/lnet/lnet/api-errno.c

diff --git a/drivers/staging/lustre/lnet/lnet/Makefile b/drivers/staging/lustre/lnet/lnet/Makefile
index 1bd9ef7..b815fe1 100644
--- a/drivers/staging/lustre/lnet/lnet/Makefile
+++ b/drivers/staging/lustre/lnet/lnet/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_LNET) += lnet.o
 
-lnet-y := api-errno.o api-ni.o config.o lib-me.o lib-msg.o lib-eq.o	\
+lnet-y := api-ni.o config.o lib-me.o lib-msg.o lib-eq.o	\
 	  lib-md.o lib-ptl.o lib-move.o module.o lo.o router.o		\
 	  router_proc.o acceptor.o peer.o
 
diff --git a/drivers/staging/lustre/lnet/lnet/api-errno.c b/drivers/staging/lustre/lnet/lnet/api-errno.c
deleted file mode 100644
index 695b272..0000000
--- a/drivers/staging/lustre/lnet/lnet/api-errno.c
+++ /dev/null
@@ -1,39 +0,0 @@
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
- * lnet/lnet/api-errno.c
- *
- * Instantiate the string table of errors
- */
-
-/* If you change these, you must update the number table in portals/errno.h */
-- 
1.7.9.5

