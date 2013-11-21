Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3KUObu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:31:50 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53380 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3KUObs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:31:48 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 03/10] staging/lustre/libcfs: remove filp_read
Date: Thu, 21 Nov 2013 22:28:24 +0800
Message-Id: <1385044111-3129-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
References: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no users.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/linux-fs.h   |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
index e523004..573ab08 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
@@ -52,9 +52,6 @@
 #include <linux/backing-dev.h>
 #include <linux/posix_acl_xattr.h>
 
-#define filp_read(fp, buf, size, pos)			\
-	((fp)->f_op->read((fp), (buf), (size), pos))
-
 #define filp_write(fp, buf, size, pos)			\
 	((fp)->f_op->write((fp), (buf), (size), pos))
 
-- 
1.7.9.5

