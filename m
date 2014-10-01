Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaJAHre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:47:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47638 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaJAHrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:47:31 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 2/5] powerpc: Adding macro for accessing Thread Switch Control Register
Date: Wed,  1 Oct 2014 13:16:54 +0530
Message-Id: <1412149617-3178-3-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412149617-3178-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1412149617-3178-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100107-6688-0000-0000-000005377243
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/reg.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 0c05059..cb65a73 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -371,6 +371,7 @@
 #define SPRN_DBAT7L	0x23F	/* Data BAT 7 Lower Register */
 #define SPRN_DBAT7U	0x23E	/* Data BAT 7 Upper Register */
 #define SPRN_PPR	0x380	/* SMT Thread status Register */
+#define SPRN_TSCR	0x399	/* Thread Switch Control Register */
 
 #define SPRN_DEC	0x016		/* Decrement Register */
 #define SPRN_DER	0x095		/* Debug Enable Regsiter */
-- 
1.9.3

