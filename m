Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305AbaLKR2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:28:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:59022 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581AbaLKR2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:28:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,558,1413270000"; 
   d="scan'208";a="646166712"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] sizes: Add 64 bit constants to sizes.h
Date: Thu, 11 Dec 2014 10:21:16 -0700
Message-Id: <1418318476-11866-1-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 64 bit ULL constants to include/linux/sizes.h.  These
sizes range from SZ_4G (4 gibibyte) through SZ_8E (8 exbibyte).

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/linux/sizes.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/sizes.h b/include/linux/sizes.h
index ce3e815..06ab35b 100644
--- a/include/linux/sizes.h
+++ b/include/linux/sizes.h
@@ -43,5 +43,40 @@
 
 #define SZ_1G				0x40000000
 #define SZ_2G				0x80000000
+#define SZ_4G				0x0000000100000000ULL
+#define SZ_8G				0x0000000200000000ULL
+#define SZ_16G				0x0000000400000000ULL
+#define SZ_32G				0x0000000800000000ULL
+#define SZ_64G				0x0000001000000000ULL
+#define SZ_128G				0x0000002000000000ULL
+#define SZ_256G				0x0000004000000000ULL
+#define SZ_512G				0x0000008000000000ULL
+
+#define SZ_1T				0x0000010000000000ULL
+#define SZ_2T				0x0000020000000000ULL
+#define SZ_4T				0x0000040000000000ULL
+#define SZ_8T				0x0000080000000000ULL
+#define SZ_16T				0x0000100000000000ULL
+#define SZ_32T				0x0000200000000000ULL
+#define SZ_64T				0x0000400000000000ULL
+#define SZ_128T				0x0000800000000000ULL
+#define SZ_256T				0x0001000000000000ULL
+#define SZ_512T				0x0002000000000000ULL
+
+#define SZ_1P				0x0004000000000000ULL
+#define SZ_2P				0x0008000000000000ULL
+#define SZ_4P				0x0010000000000000ULL
+#define SZ_8P				0x0020000000000000ULL
+#define SZ_16P				0x0040000000000000ULL
+#define SZ_32P				0x0080000000000000ULL
+#define SZ_64P				0x0100000000000000ULL
+#define SZ_128P				0x0200000000000000ULL
+#define SZ_256P				0x0400000000000000ULL
+#define SZ_512P				0x0800000000000000ULL
+
+#define SZ_1E				0x1000000000000000ULL
+#define SZ_2E				0x2000000000000000ULL
+#define SZ_4E				0x4000000000000000ULL
+#define SZ_8E				0x8000000000000000ULL
 
 #endif /* __LINUX_SIZES_H__ */
-- 
1.9.3

