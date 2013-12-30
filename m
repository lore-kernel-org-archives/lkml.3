Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab3L3Snc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:43:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:64614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab3L3SlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:41:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,575,1384329600"; 
   d="scan'208";a="451571442"
Subject: [PATCH 10/12] x86 Kconfig: MCE menu
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 30 Dec 2013 10:40:59 -0800
References: <20131230184046.F5E42919@viggo.jf.intel.com>
In-Reply-To: <20131230184046.F5E42919@viggo.jf.intel.com>
Message-Id: <20131230184059.1965F4C7@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This is a fairly small one, but it still saves 3 lines in the
top-level menu.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/Kconfig~x86-mce-menu arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-mce-menu	2013-12-30 10:37:46.271280927 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2013-12-30 10:37:46.275281107 -0800
@@ -1295,7 +1295,7 @@ config X86_VISWS_APIC
 	def_bool y
 	depends on X86_32 && X86_VISWS
 
-config X86_MCE
+menuconfig X86_MCE
 	bool "Machine Check / overheating reporting"
 	default y
 	---help---
@@ -1328,10 +1328,6 @@ config X86_ANCIENT_MCE
 	  systems. These typically need to be enabled explicitely on the command
 	  line.
 
-config X86_MCE_THRESHOLD
-	depends on X86_MCE_AMD || X86_MCE_INTEL
-	def_bool y
-
 config X86_MCE_INJECT
 	depends on X86_MCE
 	tristate "Machine check injector support"
@@ -1340,6 +1336,10 @@ config X86_MCE_INJECT
 	  If you don't know what a machine check is and you don't do kernel
 	  QA it is safe to say n.
 
+config X86_MCE_THRESHOLD
+	depends on X86_MCE_AMD || X86_MCE_INTEL
+	def_bool y
+
 config X86_THERMAL_VECTOR
 	def_bool y
 	depends on X86_MCE_INTEL
_
