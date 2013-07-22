Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3GVQJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:09:57 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65532 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3GVQJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:09:55 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 01/48] staging/lustre: remove bogus ifndef EXPORT_SYMBOL
Date: Tue, 23 Jul 2013 00:06:22 +0800
Message-Id: <1374509230-3324-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
index 9c40ed9..36def36 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
@@ -40,10 +40,6 @@
 #ifndef __LIBCFS_PRIM_H__
 #define __LIBCFS_PRIM_H__
 
-#ifndef EXPORT_SYMBOL
-# define EXPORT_SYMBOL(s)
-#endif
-
 /*
  * Schedule
  */
-- 
1.7.9.5

