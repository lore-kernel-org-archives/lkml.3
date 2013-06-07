Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3FGJoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:44:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45833 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3FGJoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:44:24 -0400
From: Davis Abubakr-Sadik Nii Nai <dwa2pac@gmail.com>
To: gregkh@linuxfoundation.org, devendra.aaru@gmail.com, plaes@plaes.org,
        dwa2pac@gmail.com, yongjun_wei@trendmicro.com.cn
Cc: devel@driverdev.osusl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: csr: fix indentation coding style issue in csr_framework_ext.h
Date: Fri,  7 Jun 2013 09:43:11 +0000
Message-Id: <1370598191-8661-1-git-send-email-dwa2pac@gmail.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to csr_framework_ext.h that fixes indentation coding style
issues found by the checkpatch.pl tool.

Signed-off-by: Davis Abubakr-Sadik Nii Nai <dwa2pac@gmail.com>
---
 drivers/staging/csr/csr_framework_ext.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/csr/csr_framework_ext.h b/drivers/staging/csr/csr_framework_ext.h
index e8ae490..6d26ac6 100644
--- a/drivers/staging/csr/csr_framework_ext.h
+++ b/drivers/staging/csr/csr_framework_ext.h
@@ -2,11 +2,11 @@
 #define CSR_FRAMEWORK_EXT_H__
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2010
-            All rights reserved and confidential information of CSR
+		(c) Cambridge Silicon Radio Limited 2010
+	All rights reserved and confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+		Refer to LICENSE.txt included with this source for details
+		on the license terms.
 
 *****************************************************************************/
 
-- 
1.8.3

