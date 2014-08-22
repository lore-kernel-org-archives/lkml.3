Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaHVMA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:00:58 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:59396 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaHVMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:00:08 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/3] x86: xen/mmu.h: Add missing #define
Date: Fri, 22 Aug 2014 13:59:18 +0200
Message-Id: <1408708759-13164-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408708759-13164-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1408708759-13164-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The #define is missing from the include guard idiom.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/x86/xen/mmu.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index 73809bb..0675f8c 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -1,4 +1,5 @@
 #ifndef _XEN_MMU_H
+#define _XEN_MMU_H
 
 #include <linux/linkage.h>
 #include <asm/page.h>
-- 
1.9.2

