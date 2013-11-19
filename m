Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3KSOmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:42:36 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63408 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3KSOmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:23 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 02/13] staging/lustre: remove liblustreapi.h
Date: Tue, 19 Nov 2013 22:38:36 +0800
Message-Id: <1384871927-8553-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is only used by user space.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/lustre/include/lustre/liblustreapi.h    |   43 --------------------
 1 file changed, 43 deletions(-)
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre/liblustreapi.h

diff --git a/drivers/staging/lustre/lustre/include/lustre/liblustreapi.h b/drivers/staging/lustre/lustre/include/lustre/liblustreapi.h
deleted file mode 100644
index 707eb74..0000000
--- a/drivers/staging/lustre/lustre/include/lustre/liblustreapi.h
+++ /dev/null
@@ -1,43 +0,0 @@
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
- * This file is part of Lustre, http://www.lustre.org/
- * Lustre is a trademark of Sun Microsystems, Inc.
- */
-
-/*
- * NOTE: This file is DEPRECATED!  Please include lustreapi.h directly
- * instead of this file.  This file will be removed from a future version
- * of lustre!
- */
-
-#ifndef _LIBLUSTREAPI_H_
-#define _LIBLUSTREAPI_H_
-
-#include <lustre/lustreapi.h>
-#warning "Including liblustreapi.h is deprecated. Include lustreapi.h directly."
-
-#endif
-- 
1.7.9.5

