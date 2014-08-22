Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbaHVMAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:00:12 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:48732 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaHVMAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:00:09 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 3/3] x86: xen/smp.h: Add missing #define
Date: Fri, 22 Aug 2014 13:59:19 +0200
Message-Id: <1408708759-13164-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408708759-13164-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1408708759-13164-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The #define is missing from the include guard idiom.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/x86/xen/smp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
index c7c2d89..b4f1561 100644
--- a/arch/x86/xen/smp.h
+++ b/arch/x86/xen/smp.h
@@ -1,4 +1,5 @@
 #ifndef _XEN_SMP_H
+#define _XEN_SMP_H
 
 extern void xen_send_IPI_mask(const struct cpumask *mask,
 			      int vector);
-- 
1.9.2

