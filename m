Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaBINTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:19:42 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55905 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaBINTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:19:40 -0500
Date: Sun, 9 Feb 2014 18:49:36 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Subject: [PATCH 18/21] fs: Include appropriate header file in proc/proc_tty.c
Message-ID: <a60ce5d775cd258a5f9b0da2185e27d52def6260.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file in proc/proc_tty.c because header file
proc/internal.h contains function prototypes of functions defined in the
file.

This eliminates the following warning in proc/proc_tty.c:
fs/proc/proc_tty.c:175:13: warning: no previous prototype for ‘proc_tty_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/proc/proc_tty.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index cb761f0..b42f6f6 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -14,6 +14,7 @@
 #include <linux/tty.h>
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
+#include "internal.h"
 
 /*
  * The /proc/tty directory inodes...
-- 
1.7.9.5

