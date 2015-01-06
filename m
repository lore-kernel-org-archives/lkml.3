Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbbAFPp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:45:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbbAFPpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:54 -0500
Date: Tue, 6 Jan 2015 17:45:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v2 38/40] s390: macro whitespace fixes
Message-ID: <1420558883-10131-39-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/s390/include/asm/uaccess.h, I noticed
that a couple of macros within this header are made harder to read
because they violate a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/s390/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index cd4c68e..71b9c40 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -46,7 +46,7 @@
 	__ctl_load(__pto, 7, 7);					\
 })
 
-#define segment_eq(a,b) ((a).ar4 == (b).ar4)
+#define segment_eq(a, b) ((a).ar4 == (b).ar4)
 
 static inline int __range_ok(unsigned long addr, unsigned long size)
 {
@@ -147,7 +147,7 @@ unsigned long __must_check __copy_to_user(void __user *to, const void *from,
 		"3:	lhi	%0,%5\n"			\
 		"	jg	2b\n"				\
 		".popsection\n"					\
-		EX_TABLE(0b,3b) EX_TABLE(1b,3b)			\
+		EX_TABLE(0b, 3b) EX_TABLE(1b, 3b)		\
 		: "=d" (__rc), "=Q" (*(to))			\
 		: "d" (size), "Q" (*(from)),			\
 		  "d" (__reg0), "K" (-EFAULT)			\
-- 
MST

