Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbaEMKE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:04:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60807 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760065AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christopher Covington <cov@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 018/182] ARM: 8007/1: Remove extraneous kcmp syscall ignore
Date: Tue, 13 May 2014 11:26:10 +0200
Message-Id: <60700517a488a9ac79ca3bc47cf9050df4075b5d.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christopher Covington <cov@codeaurora.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 95c52fe063351192e0f4ffb70ef9bac1aa26f5a4 upstream.

The kcmp system call was ported to ARM in
commit 3f7d1fe108dbaefd0c57a41753fc2c90b395f458
"ARM: 7665/1: Wire up kcmp syscall".

Fixes: 3f7d1fe108db ("ARM: 7665/1: Wire up kcmp syscall")
Signed-off-by: Christopher Covington <cov@codeaurora.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/include/asm/unistd.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 141baa3f9a72..cbd61977c996 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -48,6 +48,5 @@
  */
 #define __IGNORE_fadvise64_64
 #define __IGNORE_migrate_pages
-#define __IGNORE_kcmp
 
 #endif /* __ASM_ARM_UNISTD_H */
-- 
1.9.3

