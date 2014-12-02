Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaLBJFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:05:14 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54822 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaLBJFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:05:09 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: remove duplicate header
Date: Tue,  2 Dec 2014 14:34:58 +0530
Message-Id: <1417511098-9139-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these header files were included two times

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/unisys/include/timskmod.h | 1 -
 drivers/staging/unisys/uislib/uisutils.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/unisys/include/timskmod.h b/drivers/staging/unisys/include/timskmod.h
index de11f44..cff7983 100644
--- a/drivers/staging/unisys/include/timskmod.h
+++ b/drivers/staging/unisys/include/timskmod.h
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
-#include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
index a8466e3..7149add 100644
--- a/drivers/staging/unisys/uislib/uisutils.c
+++ b/drivers/staging/unisys/uislib/uisutils.c
@@ -27,7 +27,6 @@
 #include "vbushelper.h"
 #include <linux/uuid.h>
 #include <linux/skbuff.h>
-#include <linux/uuid.h>
 #ifdef CONFIG_HIGHMEM
 #include <linux/highmem.h>
 #endif
-- 
1.8.1.2

