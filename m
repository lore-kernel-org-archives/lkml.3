Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbbAFPpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:45:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbbAFPpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:16 -0500
Date: Tue, 6 Jan 2015 17:45:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH v2 28/40] microblaze: whitespace fix
Message-ID: <1420558883-10131-29-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align using tabs to make code prettier.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/microblaze/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index e41bebf..62942fd 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -306,7 +306,7 @@ extern long __user_bad(void);
 
 #define __put_user_check(x, ptr, size)					\
 ({									\
-	typeof(*(ptr)) volatile __pu_val = x;					\
+	typeof(*(ptr)) volatile __pu_val = x;				\
 	typeof(*(ptr)) __user *__pu_addr = (ptr);			\
 	int __pu_err = 0;						\
 									\
-- 
MST

