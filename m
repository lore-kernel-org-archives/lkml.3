Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbaCFABz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:01:55 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57365 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757328AbaCFABw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:01:52 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>, Alexander Graf <agraf@suse.de>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, scottwood@freescale.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 04/11] powerpc: add hvcalls for 24x7 and gpci (get performance counter info)
Date: Wed,  5 Mar 2014 16:01:03 -0800
Message-Id: <1394064082-6242-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030600-7182-0000-0000-000009FB891C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/hvcall.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index d8b600b..5dbbb29 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -274,6 +274,11 @@
 /* Platform specific hcalls, used by KVM */
 #define H_RTAS			0xf000
 
+/* "Platform specific hcalls", provided by PHYP */
+#define H_GET_24X7_CATALOG_PAGE	0xF078
+#define H_GET_24X7_DATA		0xF07C
+#define H_GET_PERF_COUNTER_INFO	0xF080
+
 #ifndef __ASSEMBLY__
 
 /**
-- 
1.9.0

