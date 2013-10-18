Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3JRVOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 17:14:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:4420 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab3JRVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 17:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,525,1378882800"; 
   d="scan'208";a="395149873"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com, x86@kernel.org
Cc: sathyanarayanan.kuppuswamy@linux.intel.com, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 1/3] MAINTAINERS: INTEL MID SOC: add maintainers
Date: Fri, 18 Oct 2013 14:18:48 -0700
Message-Id: <1382131130-10903-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382131130-10903-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1382131130-10903-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Low-power Intel MID SoC support is currently quite outdated.
The code is meant for the old Moorestown platform and has not proper
support for newer platforms like Medfield, Clovertrail, Merrifield, ...

This patch adds official maintainers for such platforms in order to get
things in a better shape from now on.

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

