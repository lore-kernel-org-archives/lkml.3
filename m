Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965448Ab3BNT3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:29:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58755 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758656Ab3BNT2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:28:42 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/2] x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt menu
Date: Thu, 14 Feb 2013 20:28:29 +0100
Message-Id: <1360870110-4778-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360870110-4778-1-git-send-email-bp@alien8.de>
References: <1360870110-4778-1-git-send-email-bp@alien8.de>
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
index ea763cf99906..fa835628f70b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -678,8 +678,6 @@ config PARAVIRT_SPINLOCKS
 config PARAVIRT_CLOCK
 	bool
 
-endif
-
 config PARAVIRT_DEBUG
 	bool "paravirt-ops debugging"
 	depends on PARAVIRT && DEBUG_KERNEL
@@ -687,6 +685,8 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
+endif #PARAVIRT_GUEST
+
 config NO_BOOTMEM
 	def_bool y
 
-- 
1.8.1.3.535.ga923c31

