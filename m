Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaIEEKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:10:30 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:40909 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaIEEK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:10:29 -0400
From: =?UTF-8?q?Filipe=20Gon=C3=A7alves?= <filipe@codinghighway.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Filipe=20Gon=C3=A7alves?= <filipe@codinghighway.com>
Subject: [PATCH 1/1] staging/lustre: Fixed checkpatch warning: Use #include <linux/statfs.h> instead of <asm/statfs.h>
Date: Fri,  5 Sep 2014 05:09:46 +0100
Message-Id: <1409890186-3536-1-git-send-email-filipe@codinghighway.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Filipe Gonçalves <filipe@codinghighway.com>
---
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
index 310df44..a7814f1 100644
--- a/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
+++ b/drivers/staging/lustre/lustre/lmv/lproc_lmv.c
@@ -37,7 +37,7 @@
 #define DEBUG_SUBSYSTEM S_CLASS
 
 #include <linux/seq_file.h>
-#include <asm/statfs.h>
+#include <linux/statfs.h>
 #include "../include/lprocfs_status.h"
 #include "../include/obd_class.h"
 
-- 
1.9.1

