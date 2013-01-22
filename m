Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3AVAzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:55:16 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47033 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab3AVAzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:55:13 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 2/4] tile: Add definition of NR_syscalls
Date: Mon, 21 Jan 2013 19:54:56 -0500
Message-Id: <1358816098-13070-2-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1358816098-13070-1-git-send-email-simon.marchi@polymtl.ca>
References: <1358816098-13070-1-git-send-email-simon.marchi@polymtl.ca>
X-Poly-FromMTA: ([132.207.72.18]) at Tue, 22 Jan 2013 00:55:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is required by the syscall tracepoint mechanism.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/include/uapi/asm/unistd.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/uapi/asm/unistd.h b/arch/tile/include/uapi/asm/unistd.h
index cd7b6dd..c763c86 100644
--- a/arch/tile/include/uapi/asm/unistd.h
+++ b/arch/tile/include/uapi/asm/unistd.h
@@ -20,6 +20,8 @@
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
 
+#define NR_syscalls (__NR_syscalls)
+
 /* Additional Tilera-specific syscalls. */
 #define __NR_cacheflush	(__NR_arch_specific_syscall + 1)
 __SYSCALL(__NR_cacheflush, sys_cacheflush)
-- 
1.7.1

