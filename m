Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3KSOrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:47:39 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37392 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab3KSOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:19 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 01/13] staging/lustre/libcfs: remove HAVE_MM_INLINE
Date: Tue, 19 Nov 2013 22:38:35 +0800
Message-Id: <1384871927-8553-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/kp30.h       |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index c204b67..9b30b4d 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -63,9 +63,7 @@
 #include <linux/smp.h>
 #include <linux/ctype.h>
 #include <linux/compiler.h>
-#ifdef HAVE_MM_INLINE
-# include <linux/mm_inline.h>
-#endif
+#include <linux/mm_inline.h>
 #include <linux/kallsyms.h>
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
-- 
1.7.9.5

