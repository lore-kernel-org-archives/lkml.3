Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab3HPWZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:25:09 -0400
Received: from spam2.wiktel.com ([69.89.207.152]:41894 "EHLO spam2.wiktel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab3HPWZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:25:07 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2013 18:25:07 EDT
From: Richard Laager <rlaager@wiktel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>, Chanho Min <chanho.min@lge.com>,
        Richard Yao <ryao@gentoo.org>, linux-kernel@vger.kernel.org,
        Richard Laager <rlaager@wiktel.com>
Subject: [PATCH] Correct the LZ4 license
Date: Fri, 16 Aug 2013 16:45:29 -0500
Message-Id: <1376689529-15080-1-git-send-email-rlaager@wiktel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <520D8C4C.7000704@gentoo.org>
References: <520D8C4C.7000704@gentoo.org>
X-bounce-key: wiktel.com-1;rlaager@wiktel.com;1376689533;HjxcFoDHY/0xvgcNt/3FIqaTmh4;
X-Spam-Score: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LZ4 code is listed as using the "BSD 2-Clause License".

Signed-off-by: Richard Laager <rlaager@wiktel.com>
---
 lib/lz4/lz4_compress.c   |    4 ++--
 lib/lz4/lz4_decompress.c |    6 +++---
 lib/lz4/lz4hc_compress.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/lz4/lz4_compress.c b/lib/lz4/lz4_compress.c
index fd94058..28321d8 100644
--- a/lib/lz4/lz4_compress.c
+++ b/lib/lz4/lz4_compress.c
@@ -437,7 +437,7 @@ int lz4_compress(const unsigned char *src, size_t src_len,
 exit:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lz4_compress);
+EXPORT_SYMBOL(lz4_compress);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 compressor");
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index d3414ea..411be80 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -299,7 +299,7 @@ exit_0:
 	return ret;
 }
 #ifndef STATIC
-EXPORT_SYMBOL_GPL(lz4_decompress);
+EXPORT_SYMBOL(lz4_decompress);
 #endif
 
 int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
@@ -319,8 +319,8 @@ exit_0:
 	return ret;
 }
 #ifndef STATIC
-EXPORT_SYMBOL_GPL(lz4_decompress_unknownoutputsize);
+EXPORT_SYMBOL(lz4_decompress_unknownoutputsize);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4 Decompressor");
 #endif
diff --git a/lib/lz4/lz4hc_compress.c b/lib/lz4/lz4hc_compress.c
index eb1a74f..f344f76 100644
--- a/lib/lz4/lz4hc_compress.c
+++ b/lib/lz4/lz4hc_compress.c
@@ -533,7 +533,7 @@ int lz4hc_compress(const unsigned char *src, size_t src_len,
 exit:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lz4hc_compress);
+EXPORT_SYMBOL(lz4hc_compress);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("LZ4HC compressor");
-- 
1.7.9.5

