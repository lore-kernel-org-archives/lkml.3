Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3AXRhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:37:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52927 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab3AXRhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:37:04 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/2] x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt menu
Date: Thu, 24 Jan 2013 18:39:53 +0100
Message-Id: <1359049194-17505-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <20130124173555.GJ13463@pd.tnic>
References: <20130124173555.GJ13463@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This should be under the PARAVIRT_GUEST menu.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1014e9ea88d4..fb3f76510be1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -674,8 +674,6 @@ config PARAVIRT_SPINLOCKS
 config PARAVIRT_CLOCK
 	bool
 
-endif
-
 config PARAVIRT_DEBUG
 	bool "paravirt-ops debugging"
 	depends on PARAVIRT && DEBUG_KERNEL
@@ -683,6 +681,8 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
+endif #PARAVIRT_GUEST
+
 config NO_BOOTMEM
 	def_bool y
 
-- 
1.8.1.rc3

