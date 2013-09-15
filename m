Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab3IOJhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:37:31 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:38275 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3IOJha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:37:30 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] kernel/sys.c: Remove obsolete #include <linux/kexec.h>
Date: Sun, 15 Sep 2013 11:37:04 +0200
Message-Id: <1379237824-3140-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 15d94b82565ebfb0cf27830b96e6cf5ed2d12a9a ("reboot: move
shutdown/reboot related functions to kernel/reboot.c") moved all
kexec-related functionality to kernel/reboot.c, so kernel/sys.c no longer
needs to include <linux/kexec.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/sys.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index c18ecca..c723113 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -16,7 +16,6 @@
 #include <linux/perf_event.h>
 #include <linux/resource.h>
 #include <linux/kernel.h>
-#include <linux/kexec.h>
 #include <linux/workqueue.h>
 #include <linux/capability.h>
 #include <linux/device.h>
-- 
1.7.9.5

