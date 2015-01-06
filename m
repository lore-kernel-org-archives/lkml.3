Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbbAFPpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:45:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993AbbAFPpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:31 -0500
Date: Tue, 6 Jan 2015 17:45:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH v2 32/40] avr32: macro whitespace fixes
Message-ID: <1420558883-10131-33-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/avr32/include/asm/uaccess.h, I noticed
that some macros within this header are made harder to read because they
violate a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/avr32/include/asm/uaccess.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/avr32/include/asm/uaccess.h b/arch/avr32/include/asm/uaccess.h
index 72607f3..a46f7cf 100644
--- a/arch/avr32/include/asm/uaccess.h
+++ b/arch/avr32/include/asm/uaccess.h
@@ -26,7 +26,7 @@ typedef struct {
  * For historical reasons (Data Segment Register?), these macros are misnamed.
  */
 #define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
-#define segment_eq(a,b)	((a).is_user_space == (b).is_user_space)
+#define segment_eq(a, b)	((a).is_user_space == (b).is_user_space)
 
 #define USER_ADDR_LIMIT 0x80000000
 
@@ -108,8 +108,8 @@ static inline __kernel_size_t __copy_from_user(void *to,
  *
  * Returns zero on success, or -EFAULT on error.
  */
-#define put_user(x,ptr)	\
-	__put_user_check((x),(ptr),sizeof(*(ptr)))
+#define put_user(x, ptr)	\
+	__put_user_check((x), (ptr), sizeof(*(ptr)))
 
 /*
  * get_user: - Get a simple variable from user space.
@@ -128,8 +128,8 @@ static inline __kernel_size_t __copy_from_user(void *to,
  * Returns zero on success, or -EFAULT on error.
  * On error, the variable @x is set to zero.
  */
-#define get_user(x,ptr) \
-	__get_user_check((x),(ptr),sizeof(*(ptr)))
+#define get_user(x, ptr) \
+	__get_user_check((x), (ptr), sizeof(*(ptr)))
 
 /*
  * __put_user: - Write a simple value into user space, with less checking.
@@ -150,8 +150,8 @@ static inline __kernel_size_t __copy_from_user(void *to,
  *
  * Returns zero on success, or -EFAULT on error.
  */
-#define __put_user(x,ptr) \
-	__put_user_nocheck((x),(ptr),sizeof(*(ptr)))
+#define __put_user(x, ptr) \
+	__put_user_nocheck((x), (ptr), sizeof(*(ptr)))
 
 /*
  * __get_user: - Get a simple variable from user space, with less checking.
@@ -173,8 +173,8 @@ static inline __kernel_size_t __copy_from_user(void *to,
  * Returns zero on success, or -EFAULT on error.
  * On error, the variable @x is set to zero.
  */
-#define __get_user(x,ptr) \
-	__get_user_nocheck((x),(ptr),sizeof(*(ptr)))
+#define __get_user(x, ptr) \
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
 
 extern int __get_user_bad(void);
 extern int __put_user_bad(void);
-- 
MST

