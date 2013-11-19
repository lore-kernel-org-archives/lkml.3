Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3KSOpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:45:41 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36273 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3KSOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:40 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 07/13] staging/lustre: remove CFS_SYSFS_MODULE_PARM
Date: Tue, 19 Nov 2013 22:38:41 +0800
Message-Id: <1384871927-8553-8-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more references to it.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/kp30.h       |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index 9b30b4d..d4c6716 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -77,8 +77,6 @@
 	module_param(name, type, perm);\
 	MODULE_PARM_DESC(name, desc)
 
-#define CFS_SYSFS_MODULE_PARM  1 /* module parameters accessible via sysfs */
-
 /******************************************************************************/
 /* Light-weight trace
  * Support for temporary event tracing with minimal Heisenberg effect. */
-- 
1.7.9.5

