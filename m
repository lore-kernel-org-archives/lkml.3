Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaDRCjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:39:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:28840 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaDRCjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:39:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="523026977"
From: David Cohen <david.a.cohen@linux.intel.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk,
        David Cohen <david.a.cohen@linux.intel.com>,
        Mark Gross <mark.gross@intel.com>
Subject: [PATCH] MAINTAINERS: INTEL MID SOC: add maintainer
Date: Thu, 17 Apr 2014 19:39:18 -0700
Message-Id: <1397788758-6335-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds official maintainer for low power Intel MID SoC
platforms.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Cc: Mark Gross <mark.gross@intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc67b1fdb50..b6056f33cb4d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5447,6 +5447,14 @@ W:	logfs.org
 S:	Maintained
 F:	fs/logfs/
 
+LOW-POWER INTEL MID SOC SUPPORT
+M:	David Cohen <david.a.cohen@linux.intel.com>
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
1.9.1

