Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaGULi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:38:56 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:48127 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754848AbaGULiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:38:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBXkQUVcZiEK4KIZMF49LBxaEMAWKX6g8aQ
X-IPAS-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBXkQUVcZiEK4KIZMF49LBxaEMAWKX6g8aQ
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353323"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 1/7] KVM: x86: Defining missing x86 vectors
Date: Mon, 21 Jul 2014 14:37:24 +0300
Message-Id: <1405942650-22589-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defining XE, XM and VE vector numbers.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/include/uapi/asm/kvm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d3a8778..d7dcef5 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -23,7 +23,10 @@
 #define GP_VECTOR 13
 #define PF_VECTOR 14
 #define MF_VECTOR 16
+#define AC_VECTOR 17
 #define MC_VECTOR 18
+#define XM_VECTOR 19
+#define VE_VECTOR 20
 
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
-- 
1.9.1

