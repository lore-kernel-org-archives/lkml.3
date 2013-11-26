Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab3KZPIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:08:10 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39038 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab3KZPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:08:04 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fan Yong <fan.yong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 06/12] staging/lustre: make code align in lma_incompat
Date: Tue, 26 Nov 2013 23:04:40 +0800
Message-Id: <1385478286-5525-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385478286-5525-1-git-send-email-bergwolf@gmail.com>
References: <1385478286-5525-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fan Yong <fan.yong@intel.com>

This is the coding style part of the original Lustre commit.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3335
Lustre-change: http://review.whamcloud.com/6669
Signed-off-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 08da4f3..dd94dc8 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -334,10 +334,10 @@ enum lma_compat {
  * This information is stored in lustre_mdt_attrs::lma_incompat.
  */
 enum lma_incompat {
-	LMAI_RELEASED = 0x0000001, /* file is released */
-	LMAI_AGENT = 0x00000002, /* agent inode */
-	LMAI_REMOTE_PARENT = 0x00000004, /* the parent of the object
-					    is on the remote MDT */
+	LMAI_RELEASED		= 0x00000001, /* file is released */
+	LMAI_AGENT		= 0x00000002, /* agent inode */
+	LMAI_REMOTE_PARENT	= 0x00000004, /* the parent of the object
+						 is on the remote MDT */
 };
 #define LMA_INCOMPAT_SUPP	(LMAI_AGENT | LMAI_REMOTE_PARENT)
 
-- 
1.7.9.5

