Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaFJXOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38718 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaFJXNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:13:55 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 07/10] tools: Remove leading underscores from header guards
Date: Tue, 10 Jun 2014 16:13:11 -0700
Message-Id: <1402441994-16780-8-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Underscore-capital symbols belong to the implementation, i.e. the
libc, and we are not it.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 tools/include/tools/unaligned/be_bswap.h     | 6 +++---
 tools/include/tools/unaligned/be_byteshift.h | 6 +++---
 tools/include/tools/unaligned/be_direct.h    | 6 +++---
 tools/include/tools/unaligned/be_endian.h    | 6 +++---
 tools/include/tools/unaligned/be_struct.h    | 6 +++---
 tools/include/tools/unaligned/le_bswap.h     | 6 +++---
 tools/include/tools/unaligned/le_byteshift.h | 6 +++---
 tools/include/tools/unaligned/le_direct.h    | 6 +++---
 tools/include/tools/unaligned/le_endian.h    | 6 +++---
 tools/include/tools/unaligned/le_struct.h    | 6 +++---
 10 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/tools/include/tools/unaligned/be_bswap.h b/tools/include/tools/unaligned/be_bswap.h
index 9e8d1e91fe0e..5e63da922d23 100644
--- a/tools/include/tools/unaligned/be_bswap.h
+++ b/tools/include/tools/unaligned/be_bswap.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_BE_BSWAP_H
-#define _TOOLS_BE_BSWAP_H
+#ifndef TOOLS_BE_BSWAP_H
+#define TOOLS_BE_BSWAP_H
 
 #include <stdint.h>
 
@@ -33,4 +33,4 @@ static inline void put_unaligned_be64(uint64_t val, void *_p)
 	put_unaligned_le64(__builtin_bswap64(val), _p);
 }
 
-#endif /* _TOOLS_BE_BSWAP_H */
+#endif /* TOOLS_BE_BSWAP_H */
diff --git a/tools/include/tools/unaligned/be_byteshift.h b/tools/include/tools/unaligned/be_byteshift.h
index 9850c7df2667..068a5a8b47b2 100644
--- a/tools/include/tools/unaligned/be_byteshift.h
+++ b/tools/include/tools/unaligned/be_byteshift.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_BE_BYTESHIFT_H
-#define _TOOLS_BE_BYTESHIFT_H
+#ifndef TOOLS_BE_BYTESHIFT_H
+#define TOOLS_BE_BYTESHIFT_H
 
 #include <stdint.h>
 
@@ -49,4 +49,4 @@ static inline void put_unaligned_be64(uint64_t val, void *_p)
 	put_unaligned_be32(val, p + 4);
 }
 
-#endif /* _TOOLS_BE_BYTESHIFT_H */
+#endif /* TOOLS_BE_BYTESHIFT_H */
diff --git a/tools/include/tools/unaligned/be_direct.h b/tools/include/tools/unaligned/be_direct.h
index 10a9b8229003..4f446856aa84 100644
--- a/tools/include/tools/unaligned/be_direct.h
+++ b/tools/include/tools/unaligned/be_direct.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_BE_DIRECT_H
-#define _TOOLS_BE_DIRECT_H
+#ifndef TOOLS_BE_DIRECT_H
+#define TOOLS_BE_DIRECT_H
 
 #include <stdint.h>
 
@@ -45,4 +45,4 @@ static inline void put_unaligned_be64(uint64_t val, void *_p)
 	*p = val;
 }
 
-#endif /* _TOOLS_BE_DIRECT_H */
+#endif /* TOOLS_BE_DIRECT_H */
diff --git a/tools/include/tools/unaligned/be_endian.h b/tools/include/tools/unaligned/be_endian.h
index 4106c082855e..52ee4a47e23c 100644
--- a/tools/include/tools/unaligned/be_endian.h
+++ b/tools/include/tools/unaligned/be_endian.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_BE_ENDIAN_H
-#define _TOOLS_BE_ENDIAN_H
+#ifndef TOOLS_BE_ENDIAN_H
+#define TOOLS_BE_ENDIAN_H
 
 #ifndef _BSD_SOURCE
 # define _BSD_SOURCE 1
@@ -37,4 +37,4 @@ static inline void put_unaligned_be64(uint64_t val, void *_p)
 	put_unaligned_le64(htobe64(val), _p);
 }
 
-#endif /* _TOOLS_BE_ENDIAN_H */
+#endif /* TOOLS_BE_ENDIAN_H */
diff --git a/tools/include/tools/unaligned/be_struct.h b/tools/include/tools/unaligned/be_struct.h
index 27b73bdf5a86..2543fee4acda 100644
--- a/tools/include/tools/unaligned/be_struct.h
+++ b/tools/include/tools/unaligned/be_struct.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_BE_STRUCT_H
-#define _TOOLS_BE_STRUCT_H
+#ifndef TOOLS_BE_STRUCT_H
+#define TOOLS_BE_STRUCT_H
 
 #include <stdint.h>
 
@@ -57,4 +57,4 @@ static inline void put_unaligned_be64(uint64_t val, void *_p)
 	p->v = val;
 }
 
-#endif /* _TOOLS_BE_STRUCT_H */
+#endif /* TOOLS_BE_STRUCT_H */
diff --git a/tools/include/tools/unaligned/le_bswap.h b/tools/include/tools/unaligned/le_bswap.h
index 9c70415fa782..199b42a7b862 100644
--- a/tools/include/tools/unaligned/le_bswap.h
+++ b/tools/include/tools/unaligned/le_bswap.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_LE_BSWAP_H
-#define _TOOLS_LE_BSWAP_H
+#ifndef TOOLS_LE_BSWAP_H
+#define TOOLS_LE_BSWAP_H
 
 #include <stdint.h>
 
@@ -33,4 +33,4 @@ static inline void put_unaligned_le64(uint64_t val, void *_p)
 	put_unaligned_be64(__builtin_bswap64(val), _p);
 }
 
-#endif /* _TOOLS_LE_BSWAP_H */
+#endif /* TOOLS_LE_BSWAP_H */
diff --git a/tools/include/tools/unaligned/le_byteshift.h b/tools/include/tools/unaligned/le_byteshift.h
index 819ba186ede5..dfd5d42b9783 100644
--- a/tools/include/tools/unaligned/le_byteshift.h
+++ b/tools/include/tools/unaligned/le_byteshift.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_LE_BYTESHIFT_H
-#define _TOOLS_LE_BYTESHIFT_H
+#ifndef TOOLS_LE_BYTESHIFT_H
+#define TOOLS_LE_BYTESHIFT_H
 
 #include <stdint.h>
 
@@ -49,4 +49,4 @@ static inline void put_unaligned_le64(uint64_t val, void *_p)
 	put_unaligned_le32(val >> 32, p + 4);
 }
 
-#endif /* _TOOLS_LE_BYTESHIFT_H */
+#endif /* TOOLS_LE_BYTESHIFT_H */
diff --git a/tools/include/tools/unaligned/le_direct.h b/tools/include/tools/unaligned/le_direct.h
index 6353dfd04fd7..17b773284edd 100644
--- a/tools/include/tools/unaligned/le_direct.h
+++ b/tools/include/tools/unaligned/le_direct.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_LE_DIRECT_H
-#define _TOOLS_LE_DIRECT_H
+#ifndef TOOLS_LE_DIRECT_H
+#define TOOLS_LE_DIRECT_H
 
 #include <stdint.h>
 
@@ -45,4 +45,4 @@ static inline void put_unaligned_le64(uint64_t val, void *_p)
 	*p = val;
 }
 
-#endif /* _TOOLS_LE_DIRECT_H */
+#endif /* TOOLS_LE_DIRECT_H */
diff --git a/tools/include/tools/unaligned/le_endian.h b/tools/include/tools/unaligned/le_endian.h
index 0429f1b29250..bc8c2d41be0e 100644
--- a/tools/include/tools/unaligned/le_endian.h
+++ b/tools/include/tools/unaligned/le_endian.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_LE_ENDIAN_H
-#define _TOOLS_LE_ENDIAN_H
+#ifndef TOOLS_LE_ENDIAN_H
+#define TOOLS_LE_ENDIAN_H
 
 #ifndef _BSD_SOURCE
 # define _BSD_SOURCE 1
@@ -37,4 +37,4 @@ static inline void put_unaligned_le64(uint64_t val, void *_p)
 	put_unaligned_be64(htole64(val), _p);
 }
 
-#endif /* _TOOLS_LE_ENDIAN_H */
+#endif /* TOOLS_LE_ENDIAN_H */
diff --git a/tools/include/tools/unaligned/le_struct.h b/tools/include/tools/unaligned/le_struct.h
index 281b03b8f316..f6f271a5824b 100644
--- a/tools/include/tools/unaligned/le_struct.h
+++ b/tools/include/tools/unaligned/le_struct.h
@@ -1,5 +1,5 @@
-#ifndef _TOOLS_LE_STRUCT_H
-#define _TOOLS_LE_STRUCT_H
+#ifndef TOOLS_LE_STRUCT_H
+#define TOOLS_LE_STRUCT_H
 
 #include <stdint.h>
 
@@ -57,4 +57,4 @@ static inline void put_unaligned_le64(uint64_t val, void *_p)
 	p->v = val;
 }
 
-#endif /* _TOOLS_LE_STRUCT_H */
+#endif /* TOOLS_LE_STRUCT_H */
-- 
1.9.3

