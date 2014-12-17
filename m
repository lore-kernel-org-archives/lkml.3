Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaLQR7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:59:53 -0500
Received: from mail-pa0-f65.google.com ([209.85.220.65]:44876 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaLQR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:59:52 -0500
From: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hariharan Rangasamy <hariharanrangasamy@gmail.com>
Subject: [PATCH 1/2] Staging: lustre: lproc_osc.c : Added #include <linux/statfs.h> instead of #include <asm/statfs.h>
Date: Wed, 17 Dec 2014 23:29:27 +0530
Message-Id: <1418839168-7921-1-git-send-email-hariharanrangasamy@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used #include <linux/statfs.h> instead of #include <asm/statfs.h>

Signed-off-by: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
---
 drivers/staging/lustre/lustre/osc/lproc_osc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
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

