Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3KUOcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:32:35 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46852 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab3KUOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:32:12 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 10/10] staging/lustre/libcfs: remove LI_POISON
Date: Thu, 21 Nov 2013 22:28:31 +0800
Message-Id: <1385044111-3129-11-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
References: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extactly same definition exitst in lustre_lib.h.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/kp30.h       |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index 8cab09c..5cc7ba0 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -70,16 +70,6 @@
 
 #include <linux/libcfs/linux/portals_compat25.h>
 
-/* ------------------------------------------------------------------ */
-
-# define LI_POISON 0x5a5a5a5a
-#if BITS_PER_LONG > 32
-# define LL_POISON 0x5a5a5a5a5a5a5a5aL
-#else
-# define LL_POISON 0x5a5a5a5aL
-#endif
-# define LP_POISON ((void *)LL_POISON)
-
 /* this is a bit chunky */
 
 # define LPU64 "%llu"
-- 
1.7.9.5

