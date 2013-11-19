Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3KSOm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:42:59 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38560 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3KSOmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:52 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 10/13] staging/lustre: remove _LWORDSIZE
Date: Tue, 19 Nov 2013 22:38:44 +0800
Message-Id: <1384871927-8553-11-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/kp30.h       |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index fedf086..44f490c 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -185,8 +185,6 @@ extern int  lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
 
 /* this is a bit chunky */
 
-#define _LWORDSIZE BITS_PER_LONG
-
 # define LPU64 "%llu"
 # define LPD64 "%lld"
 # define LPX64 "%#llx"
@@ -206,9 +204,6 @@ extern int  lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
  */
 # define LPPID "%d"
 
-
-#undef _LWORDSIZE
-
 /* compat macroses */
 
 
-- 
1.7.9.5

