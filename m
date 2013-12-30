Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3L3SlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:41:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:59266 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280Ab3L3SlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:41:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,575,1384329600"; 
   d="scan'208";a="431816003"
Subject: [PATCH 09/12] x86 Kconfig: create mtrr menu
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 30 Dec 2013 10:40:58 -0800
References: <20131230184046.F5E42919@viggo.jf.intel.com>
In-Reply-To: <20131230184046.F5E42919@viggo.jf.intel.com>
Message-Id: <20131230184058.0A59E033@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This removes another 4 lines from the default x86 menu.  Note
that I slightly changed the MTRR prompt text since PAT is
hidden under here.  This makes PAT easier to find since it
"depends on MTRR" anyway.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/Kconfig~x86-mtrr-menu arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-mtrr-menu	2013-12-30 10:37:45.990268296 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2013-12-30 10:37:45.995268521 -0800
@@ -1387,9 +1387,9 @@ config MATH_EMULATION
 	  If you are not sure, say Y; apart from resulting in a 66 KB bigger
 	  kernel, it won't hurt.
 
-config MTRR
+menuconfig MTRR
 	def_bool y
-	prompt "MTRR (Memory Type Range Register) support" if EXPERT
+	prompt "MTRR (Memory Type Range Register) and PAT support" if EXPERT
 	---help---
 	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
 	  the Memory Type Range Registers (MTRRs) may be used to control
_
