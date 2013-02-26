Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab3BZLFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:05:35 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58351 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab3BZLEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:04:09 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/5] metag: remove GENERIC_SIGALTSTACK
Date: Tue, 26 Feb 2013 11:03:59 +0000
Message-ID: <1361876642-10247-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
References: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_26_11_04_09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "burying unused conditionals" removed among other things the
CONFIG_GENERIC_SIGALTSTACK Kconfig symbol as it's selected by every
architecture. Therefore remove the select from CONFIG_METAG too.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/metag/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 30adc78..46d0fa7 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -8,7 +8,6 @@ config METAG
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_SHOW
-	select GENERIC_SIGALTSTACK
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_64BIT_ALIGNED_ACCESS
 	select HAVE_ARCH_TRACEHOOK
-- 
1.8.1.2


