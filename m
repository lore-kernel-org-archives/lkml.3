Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaJ1Bam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 21:30:42 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51100 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaJ1Bal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 21:30:41 -0400
From: Gregory Fong <gregory.0xf0@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory Fong <gregory.0xf0@gmail.com>
Subject: [PATCH] ARM: Clarify do_div() usage
Date: Mon, 27 Oct 2014 18:29:30 -0700
Message-Id: <1414459770-31592-1-git-send-email-gregory.0xf0@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above do_div() makes it look like the first argument is
supposed to be a pointer to the dividend, so add a note to explain
further.

Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
---
 arch/arm/include/asm/div64.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/include/asm/div64.h b/arch/arm/include/asm/div64.h
index 662c7bd..993489f 100644
--- a/arch/arm/include/asm/div64.h
+++ b/arch/arm/include/asm/div64.h
@@ -14,6 +14,9 @@
  * 	return remainder;
  * }
  *
+ * Note that "*n" does not mean the first argument should be a
+ * pointer, but rather indicates that the value is modified in-place.
+ *
  * In other words, a 64-bit dividend with a 32-bit divisor producing
  * a 64-bit result and a 32-bit remainder.  To accomplish this optimally
  * we call a special __do_div64 helper with completely non standard
-- 
1.9.1

