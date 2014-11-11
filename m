Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaKKWBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:01:48 -0500
Received: from mga03.intel.com ([134.134.136.65]:2936 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbaKKWBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:01:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="635316336"
Subject: [PATCH 1/2] x86: xsave.h needs user.h
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        fenghua.yu@intel.com, x86@kernel.org
From: Dave Hansen <dave@sr71.net>
Date: Tue, 11 Nov 2014 14:01:31 -0800
Message-Id: <20141111220131.D86EE670@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

xsave.h uses USER_XSTATE_FX_SW_WORDS, but does not include user.h.

Add the include.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: x86@kernel.org

---

 b/arch/x86/include/asm/xsave.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/include/asm/xsave.h~x86-xsave.h-needs-user.h arch/x86/include/asm/xsave.h
--- a/arch/x86/include/asm/xsave.h~x86-xsave.h-needs-user.h	2014-11-11 14:00:18.844366889 -0800
+++ b/arch/x86/include/asm/xsave.h	2014-11-11 14:00:18.846366979 -0800
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <asm/processor.h>
+#include <asm/user.h>
 
 #define XSTATE_CPUID		0x0000000d
 
_
