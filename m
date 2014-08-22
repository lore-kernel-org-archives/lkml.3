Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaHVMAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:00:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60561 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaHVMAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:00:07 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 1/3] x86: kernel/tls.h: Add missing #define
Date: Fri, 22 Aug 2014 13:59:17 +0200
Message-Id: <1408708759-13164-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro name suggests that the include guard idiom was meant, but
the #define was missing.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/x86/kernel/tls.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/tls.h b/arch/x86/kernel/tls.h
index 2f083a2..a18e48b 100644
--- a/arch/x86/kernel/tls.h
+++ b/arch/x86/kernel/tls.h
@@ -11,6 +11,7 @@
  */
 
 #ifndef _ARCH_X86_KERNEL_TLS_H
+#define _ARCH_X86_KERNEL_TLS_H
 
 #include <linux/regset.h>
 
-- 
1.9.2

