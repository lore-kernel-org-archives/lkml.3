Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaB1RuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:50:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:8847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaB1Rtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:49:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,563,1389772800"; 
   d="scan'208";a="464330117"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: "David E. Box" <david.e.box@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        jacob.jun.pan@intel.com
Subject: [PATCH V4 2/2] x86: IOSF: Change IOSF_MBI Kconfig to default y
Date: Fri, 28 Feb 2014 09:47:54 -0800
Message-Id: <1393609674-2999-3-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393609674-2999-1-git-send-email-david.e.box@linux.intel.com>
References: <1393609674-2999-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1393443617-8923-1-git-send-email-david.e.box@linux.intel.com>
References: <1393443617-8923-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

Make the IOSF Mailbox driver built in as it's a very small piece of code that
provides core functionality needed for new Intel SOC platforms to access the
device registers on the SOC.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/Kconfig |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d3b1f8b..4f31ad3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2385,12 +2385,8 @@ config X86_DMA_REMAP
 	depends on STA2X11
 
 config IOSF_MBI
-	bool
+	def_bool y
 	depends on PCI
-	---help---
-	  To be selected by modules requiring access to the Intel OnChip System
-	  Fabric (IOSF) Sideband MailBox Interface (MBI). For MBI platforms
-	  enumerable by PCI.
 
 source "net/Kconfig"
 
-- 
1.7.10.4

