Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaLQTZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:25:24 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44432 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaLQTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:25:18 -0500
Message-ID: <1418844306.9555.0.camel@hari-laptop>
Subject: [PATCH 1/2] Staging: lustre: lproc_osc.c : Added #include
 <linux/statfs.h> instead of #include <asm/statfs.h>
From: Hariharan <rhariharan.cbe@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Date: Thu, 18 Dec 2014 00:55:06 +0530
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2a84ceb9e5043a5700d35108ec72737be5102356 Mon Sep 17 00:00:00 2001
From: Hariharan Rangasamy <rhariharan.cbe@gmail.com>
Date: Wed, 17 Dec 2014 23:57:47 +0530
Subject: [PATCH 1/2] Staging: lustre: lproc_osc.c : Added #include
 <linux/statfs.h> instead of #include <asm/statfs.h>

Used #include <linux/statfs.h> instead of #include <asm/statfs.h>

Signed-off-by: Hariharan Rangasamy <rhariharan.cbe@gmail.com>
---
 drivers/staging/lustre/lustre/osc/lproc_osc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c
b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index 9f719bc..f578b51 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -35,7 +35,7 @@
  */
 #define DEBUG_SUBSYSTEM S_CLASS
 
-#include <asm/statfs.h>
+#include <linux/statfs.h>
 #include "../include/obd_cksum.h"
 #include "../include/obd_class.h"
 #include "../include/lprocfs_status.h"
-- 
1.9.1



