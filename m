Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab3APJpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:45:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446Ab3APJpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:45:43 -0500
From: hamo@canonical.com
To: viro@zeniv.linux.org.uk
Cc: hamo.by@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] Update comments to match the current code
Date: Wed, 16 Jan 2013 17:45:36 +0800
Message-Id: <1358329536-6778-1-git-send-email-hamo@canonical.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Bai <hamo.by@gmail.com>

Since fs/super.c has changed a lot and fs/namespace.c appears, the
comments at the head of the files do not match the code.

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 fs/namespace.c | 4 ++++
 fs/super.c     | 7 +------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 55605c5..238a09c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4,6 +4,10 @@
  * (C) Copyright Al Viro 2000, 2001
  *	Released under GPL v2.
  *
+ *  namespace.c contains code to handle: - mount system call
+ *                                       - umount system call
+ *                                       - pivot_root system call
+ *
  * Based on code from fs/super.c, copyright Linus Torvalds and others.
  * Heavily rewritten.
  */
diff --git a/fs/super.c b/fs/super.c
index 12f1237..ebe411d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -3,12 +3,7 @@
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
- *  super.c contains code to handle: - mount structures
- *                                   - super-block tables
- *                                   - filesystem drivers list
- *                                   - mount system call
- *                                   - umount system call
- *                                   - ustat system call
+ *  super.c contains code to handle: - super-block tables
  *
  * GK 2/5/95  -  Changed to support mounting the root fs via NFS
  *
-- 
1.8.1.1

