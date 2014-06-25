Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaFYE6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 00:58:45 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63588 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaFYE6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 00:58:43 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 4/4] staging: lustre: llite: dir.c - fix for coding style issues
Date: Wed, 25 Jun 2014 14:57:30 +1000
Message-Id: <1403672250-19048-4-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403672250-19048-1-git-send-email-askb23@gmail.com>
References: <1403672250-19048-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this fixes some coding style issues "ERROR: "(foo*)" should be "(foo *)"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/llite/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 5d096d8..6efaf03 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1266,7 +1266,7 @@ static long ll_dir_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (mdtidx < 0)
 			return mdtidx;
 
-		if (put_user((int)mdtidx, (int*)arg))
+		if (put_user((int)mdtidx, (int *)arg))
 			return -EFAULT;
 
 		return 0;
@@ -1778,7 +1778,7 @@ out_quotactl:
 			return -EFAULT;
 		return 0;
 	case LL_IOC_GET_CONNECT_FLAGS: {
-		return obd_iocontrol(cmd, sbi->ll_md_exp, 0, NULL, (void*)arg);
+		return obd_iocontrol(cmd, sbi->ll_md_exp, 0, NULL, (void *)arg);
 	}
 	case OBD_IOC_CHANGELOG_SEND:
 	case OBD_IOC_CHANGELOG_CLEAR:
-- 
1.9.0

