Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3JLEvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:51:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:8640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab3JLEvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,480,1378882800"; 
   d="scan'208";a="391917617"
From: David Cohen <david.a.cohen@linux.intel.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: David Cohen <david.a.cohen@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 1/1] MAINTAINERS: INTEL MID SOC: add maintainers
Date: Fri, 11 Oct 2013 21:55:04 -0700
Message-Id: <1381553704-23321-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381553704-23321-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1381553704-23321-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds official maintainers for low-power Intel MID platform.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7534a80..8ef9e65 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7570,6 +7570,15 @@ F:	arch/x86/platform/sfi/
 F:	drivers/sfi/
 F:	include/linux/sfi*.h
 
+LOW-POWER INTEL MID SOC SUPPORT
+M:	David Cohen <david.a.cohen@linux.intel.com>
+M:	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
+S:	Supported
+F:	arch/x86/platform/intel-mid/
+F:	arch/x86/pci/intel_mid_pci.c
+F:	arch/x86/include/asm/intel-mid.h
+F:	arch/x86/include/asm/intel_mid*.h
+
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
 P:	Vincent Sanders <vince@simtec.co.uk>
-- 
1.8.4.rc3

