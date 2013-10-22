Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3JVMOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:14:42 -0400
Received: from services.gouders.net ([141.101.32.176]:46051 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3JVMOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:14:40 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC trivial] printk.c: /proc/vmcore instead of /proc/vmcoreinfo in comments?
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Tue, 22 Oct 2013 14:15:24 +0200
Message-ID: <gik3h5tsbn.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hello Joe,

when having a look at printk.c, I noticed that two comments refer
to /proc/vmcoreinfo and I wonder if that should not read /proc/vmcore.

While at it, a typo in one of those coments could also be fixed.

Best regards,

Dirk


--=-=-=
Content-Type: text/plain
Content-Disposition: inline;
 filename=0001-printk.c-comments-should-refer-to-proc-vmcore-instea.patch
Content-Description: Patch

>From 2ef84ff3187633a3156c3a967c1dfc294292e492 Mon Sep 17 00:00:00 2001
From: Dirk Gouders <dirk@gouders.net>
Date: Tue, 22 Oct 2013 13:51:15 +0200
Subject: [PATCH] printk.c: comments should refer to /proc/vmcore instead of
 /proc/vmcoreinfo

In one of those comments a typo was fixed, too.

Signed-off-by: Dirk Gouders <dirk@gouders.net>
---
 kernel/printk/printk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b4e8500..694d1f9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -705,9 +705,9 @@ const struct file_operations kmsg_fops = {
 
 #ifdef CONFIG_KEXEC
 /*
- * This appends the listed symbols to /proc/vmcoreinfo
+ * This appends the listed symbols to /proc/vmcore
  *
- * /proc/vmcoreinfo is used by various utiilties, like crash and makedumpfile to
+ * /proc/vmcore is used by various utilities, like crash and makedumpfile to
  * obtain access to symbols that are otherwise very difficult to locate.  These
  * symbols are specifically used so that utilities can access and extract the
  * dmesg log from a vmcore file after a crash.
-- 
1.8.3.2


--=-=-=--
