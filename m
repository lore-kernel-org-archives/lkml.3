Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaBNSi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:38:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59365 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaBNSiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:38:25 -0500
From: Christopher Covington <cov@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH] ARM: Remove extraneous kcmp syscall ignore
Date: Fri, 14 Feb 2014 13:38:19 -0500
Message-Id: <1392403099-13411-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kcmp system call was ported to ARM in
commit 3f7d1fe108dbaefd0c57a41753fc2c90b395f458
"ARM: 7665/1: Wire up kcmp syscall".

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm/include/asm/unistd.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 141baa3..cbd6197 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -48,6 +48,5 @@
  */
 #define __IGNORE_fadvise64_64
 #define __IGNORE_migrate_pages
-#define __IGNORE_kcmp
 
 #endif /* __ASM_ARM_UNISTD_H */
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

