Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaKPMeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:34:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35574 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbaKPMeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:34:18 -0500
Date: Sun, 16 Nov 2014 04:34:06 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-b48cbd27b38ed3aef56a02dca2a4853fa5dabb1f@git.kernel.org>
Cc: fenghua.yu@intel.com, mingo@kernel.org, tglx@linutronix.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Reply-To: dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, fenghua.yu@intel.com, mingo@kernel.org,
        tglx@linutronix.de
In-Reply-To: <20141111220131.D86EE670@viggo.jf.intel.com>
References: <20141111220131.D86EE670@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: Add #include user.h to xsave.h
Git-Commit-ID: b48cbd27b38ed3aef56a02dca2a4853fa5dabb1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b48cbd27b38ed3aef56a02dca2a4853fa5dabb1f
Gitweb:     http://git.kernel.org/tip/b48cbd27b38ed3aef56a02dca2a4853fa5dabb1f
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Tue, 11 Nov 2014 14:01:31 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:30:39 +0100

x86: Add #include user.h to xsave.h

xsave.h uses USER_XSTATE_FX_SW_WORDS, but does not include
user.h.

Add the include.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/20141111220131.D86EE670@viggo.jf.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/xsave.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 7e7a79a..047797a 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <asm/processor.h>
+#include <asm/user.h>
 
 #define XSTATE_CPUID		0x0000000d
 
