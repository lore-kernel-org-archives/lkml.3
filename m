Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3JRVaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 17:30:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:45623 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab3JRVaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 17:30:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,525,1378882800"; 
   d="scan'208";a="421366209"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com, x86@kernel.org
Cc: sathyanarayanan.kuppuswamy@linux.intel.com, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v1.1 1/3] MAINTAINERS: INTEL MID SOC: add maintainers
Date: Fri, 18 Oct 2013 14:34:33 -0700
Message-Id: <1382132073-11294-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382131130-10903-2-git-send-email-david.a.cohen@linux.intel.com>
References: <1382131130-10903-2-git-send-email-david.a.cohen@linux.intel.com>
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
index 7534a80..25a0aa0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5203,6 +5203,15 @@ W:	logfs.org
 S:	Maintained
 F:	fs/logfs/
 
+LOW-POWER INTEL MID SOC SUPPORT
+M:	David Cohen <david.a.cohen@linux.intel.com>
+M:	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
+S:	Supported
+F:	arch/x86/platform/intel-mid/
+F:	arch/x86/pci/intel_mid_pci.c
+F:	arch/x86/include/asm/intel-mid.h
+F:	arch/x86/include/asm/intel_mid*.h
+
 LPC32XX MACHINE SUPPORT
 M:	Roland Stigge <stigge@antcom.de>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.8.4.rc3

