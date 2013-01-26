Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3AZXII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 18:08:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45521 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab3AZXIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 18:08:06 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH -v3 1/2] x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt menu
Date: Sun, 27 Jan 2013 00:10:50 +0100
Message-Id: <1359241851-7594-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <20130125190340.GC4973@pd.tnic>
References: <20130125190340.GC4973@pd.tnic>
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
index 2d621032525a..201b8aa93f8f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -631,8 +631,6 @@ config PARAVIRT_SPINLOCKS
 config PARAVIRT_CLOCK
 	bool
 
-endif
-
 config PARAVIRT_DEBUG
 	bool "paravirt-ops debugging"
 	depends on PARAVIRT && DEBUG_KERNEL
@@ -640,6 +638,8 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
+endif #PARAVIRT_GUEST
+
 config NO_BOOTMEM
 	def_bool y
 
-- 
1.8.1.rc3

