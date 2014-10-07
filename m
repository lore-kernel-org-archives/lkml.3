Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaJGTyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:54:23 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60117 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbaJGTyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:54:21 -0400
From: Faisal Abbas <90.abbasfaisal@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com
Cc: x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Faisal Abbas <90.abbasfaisal@gmail.com>
Subject: [PATCH] arch/x86/xen/smp.h: Remove a semicolon to fix build error.
Date: Wed,  8 Oct 2014 00:54:08 +0500
Message-Id: <1412711649-18471-1-git-send-email-90.abbasfaisal@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an improper semicolon with which linux next tree won't compile.

Signed-off-by: Faisal Abbas <90.abbasfaisal@gmail.com>
---
 arch/x86/xen/smp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
index eed00a8..963d62a 100644
--- a/arch/x86/xen/smp.h
+++ b/arch/x86/xen/smp.h
@@ -11,7 +11,7 @@ extern void xen_send_IPI_self(int vector);
 #ifdef CONFIG_XEN_PVH
 extern void xen_pvh_early_cpu_init(int cpu, bool entry);
 #else
-static inline void xen_pvh_early_cpu_init(int cpu, bool entry);
+static inline void xen_pvh_early_cpu_init(int cpu, bool entry)
 {
 }
 #endif
-- 
1.7.9.5

