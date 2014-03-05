Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaCENbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:31:34 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61999 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaCENbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:31:32 -0500
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 5/6] staging/lustre/libcfs: remove obsolete function declaration
Date: Wed,  5 Mar 2014 21:27:19 +0800
Message-Id: <1394026040-1968-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1394026040-1968-4-git-send-email-bergwolf@gmail.com>
References: <1394026040-1968-1-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-2-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-3-git-send-email-bergwolf@gmail.com>
 <1394026040-1968-4-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_string.h    |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
index 73c251f..509dc1e 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_string.h
@@ -49,18 +49,6 @@ int cfs_strncasecmp(const char *s1, const char *s2, size_t n);
 /* Convert a text string to a bitmask */
 int cfs_str2mask(const char *str, const char *(*bit2str)(int bit),
 		 int *oldmask, int minmask, int allmask);
-
-/* Allocate space for and copy an existing string.
- * Must free with kfree().
- */
-char *cfs_strdup(const char *str, u_int32_t flags);
-
-/* safe vsnprintf */
-int cfs_vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
-
-/* safe snprintf */
-int cfs_snprintf(char *buf, size_t size, const char *fmt, ...);
-
 /* trim leading and trailing space characters */
 char *cfs_firststr(char *str, size_t size);
 
-- 
1.7.7.6

