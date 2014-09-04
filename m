Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaIDTGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:06:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:41424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbaIDTGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:06:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,467,1406617200"; 
   d="scan'208";a="475257291"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Borislav Petkov" <bp@alien8.de>,
        "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH] x86/microcode: add parameter dis_ucode_ldr in kernel-paramenters.txt
Date: Thu,  4 Sep 2014 12:07:06 -0700
Message-Id: <1409857626-55464-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

The kernel parameter dis_ucode_ldr disables early loading microcode from
initrd. The parameter was introduced earlier by Borislave Petkov.

This patch adds the explanation for this parameter in
Documentation/kernel-parameters.txt for user convenience.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/kernel-parameters.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5ae8608..eef098f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -841,6 +841,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
 
+	dis_ucode_ldr	[X86]
+			This parameter disables the early microcode loader.
+			This is useful mostly in debugging situations where
+			we want to turn off early microcode loading from the
+			initrd, as a means to be able to rule out its
+			influence on the machine.
+
 	disable=	[IPV6]
 			See Documentation/networking/ipv6.txt.
 
-- 
1.8.1.2

