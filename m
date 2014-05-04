Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaEDQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:16:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaEDPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.10 11/86] ARM: 8007/1: Remove extraneous kcmp syscall ignore
Date: Sun,  4 May 2014 11:40:46 -0400
Message-Id: <20140504154141.950722958@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Covington <cov@codeaurora.org>

commit 95c52fe063351192e0f4ffb70ef9bac1aa26f5a4 upstream.

The kcmp system call was ported to ARM in
commit 3f7d1fe108dbaefd0c57a41753fc2c90b395f458
"ARM: 7665/1: Wire up kcmp syscall".

Fixes: 3f7d1fe108db ("ARM: 7665/1: Wire up kcmp syscall")
Signed-off-by: Christopher Covington <cov@codeaurora.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/unistd.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -48,6 +48,5 @@
  */
 #define __IGNORE_fadvise64_64
 #define __IGNORE_migrate_pages
-#define __IGNORE_kcmp
 
 #endif /* __ASM_ARM_UNISTD_H */


