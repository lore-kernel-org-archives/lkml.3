Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399AbaHYSCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:02:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42721 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606AbaHYSCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:02:07 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 6/9] powerpc: Adding macro for accessing Thread Switch Control Register
Date: Mon, 25 Aug 2014 23:31:10 +0530
Message-Id: <1408989673-14137-7-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408989673-14137-1-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1408989673-14137-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082518-7182-0000-0000-00000047CF83
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
1.9.0

